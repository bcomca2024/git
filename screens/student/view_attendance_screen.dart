// View Attendance Screen.Dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../services/auth_service.dart';

class ViewAttendanceScreen extends StatefulWidget {
  @override
  _ViewAttendanceScreenState createState() => _ViewAttendanceScreenState();
}

class _ViewAttendanceScreenState extends State<ViewAttendanceScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Attendance'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Date Selection
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 8),
                          Text(
                            'Selected Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Attendance Record
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _databaseService.getAttendanceByDate(_selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Filter for current user's attendance
                String? currentUserId = _authService.currentUser?.uid;
                var userAttendance = snapshot.data?.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return data['studentId'] == currentUserId;
                }).toList() ?? [];

                if (userAttendance.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No attendance record found for this date',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Select a different date to view your attendance',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: userAttendance.length,
                  itemBuilder: (context, index) {
                    var attendance = userAttendance[index].data() as Map<String, dynamic>;
                    bool isPresent = attendance['present'] ?? false;
                    
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isPresent ? Colors.green : Colors.red,
                          child: Icon(
                            isPresent ? Icons.check : Icons.close,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          isPresent ? 'Present' : 'Absent',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isPresent ? Colors.green : Colors.red,
                          ),
                        ),
                        subtitle: Text(
                          'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        ),
                        trailing: Icon(
                          isPresent ? Icons.sentiment_very_satisfied : Icons.sentiment_dissatisfied,
                          color: isPresent ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // Attendance Summary
          Container(
            padding: EdgeInsets.all(16),
            child: Card(
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Attendance Summary',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'View your daily attendance records by selecting different dates above.',
                      style: TextStyle(color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }
}
