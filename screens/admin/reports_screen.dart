// Reports Screen.Dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database_service.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final DatabaseService _databaseService = DatabaseService();
  String _selectedReport = 'attendance';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Report Type Selection
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text('Report Type: ', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedReport,
                  items: [
                    DropdownMenuItem(value: 'attendance', child: Text('Attendance Report')),
                    DropdownMenuItem(value: 'students', child: Text('Student Report')),
                    DropdownMenuItem(value: 'assignments', child: Text('Assignment Report')),
                  ],
                  onChanged: (value) => setState(() => _selectedReport = value!),
                ),
              ],
            ),
          ),
          
          // Report Content
          Expanded(
            child: _buildReportContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent() {
    switch (_selectedReport) {
      case 'attendance':
        return _buildAttendanceReport();
      case 'students':
        return _buildStudentReport();
      case 'assignments':
        return _buildAssignmentReport();
      default:
        return Center(child: Text('Select a report type'));
    }
  }

  Widget _buildAttendanceReport() {
    return StreamBuilder<QuerySnapshot>(
      stream: _databaseService.getStudents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No data available'));
        }

        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Attendance Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text('Total Students: ${snapshot.data!.docs.length}'),
                    Text('Present Today: ${snapshot.data!.docs.where((doc) => (doc.data() as Map)['present'] == true).length}'),
                    Text('Absent Today: ${snapshot.data!.docs.where((doc) => (doc.data() as Map)['present'] == false).length}'),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStudentReport() {
    return StreamBuilder<QuerySnapshot>(
      stream: _databaseService.getStudents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        Map<String, int> yearCounts = {};
        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            String year = (doc.data() as Map)['year'] ?? '1';
            yearCounts[year] = (yearCounts[year] ?? 0) + 1;
          }
        }

        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Student Distribution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    ...yearCounts.entries.map((entry) => 
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text('Year ${entry.key}: ${entry.value} students'),
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAssignmentReport() {
    return StreamBuilder<QuerySnapshot>(
      stream: _databaseService.getAssignments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        int totalAssignments = snapshot.data?.docs.length ?? 0;
        int overdueAssignments = 0;
        
        if (snapshot.hasData) {
          overdueAssignments = snapshot.data!.docs.where((doc) {
            var data = doc.data() as Map;
            if (data['dueDate'] != null) {
              DateTime dueDate = (data['dueDate'] as Timestamp).toDate();
              return dueDate.isBefore(DateTime.now());
            }
            return false;
          }).length;
        }

        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Assignment Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text('Total Assignments: $totalAssignments'),
                    Text('Overdue Assignments: $overdueAssignments'),
                    Text('Active Assignments: ${totalAssignments - overdueAssignments}'),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
