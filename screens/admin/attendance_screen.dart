import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database_service.dart';
import '../../models/student_model.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final DatabaseService _databaseService = DatabaseService();
  DateTime _selectedDate = DateTime.now();
  String _selectedYear = '1';
  Map<String, bool> _attendance = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveAttendance,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date and Year Selection
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 8),
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedYear,
                  items: ['1', '2', '3'].map((year) {
                    return DropdownMenuItem(value: year, child: Text('Year $year'));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value!;
                      _attendance.clear(); // Clear attendance when year changes
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Students List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _databaseService.getStudentsByYear(_selectedYear),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No students found for Year $_selectedYear'));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    // Additional safety check for index bounds
                    if (index >= snapshot.data!.docs.length) {
                      return SizedBox.shrink(); 
                    }
                    
                    try {
                      StudentModel student = StudentModel.fromFirestore(snapshot.data!.docs[index]);
                      bool isPresent = _attendance[student.id] ?? false;
                      
                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isPresent ? Colors.green : Colors.red,
                            child: Text(
                              student.studentName.isNotEmpty 
                                ? student.studentName[0].toUpperCase() 
                                : '?'
                            ),
                          ),
                          title: Text(student.studentName.isNotEmpty ? student.studentName : 'No Name'),
                          subtitle: Text('Roll: ${student.rollNumber.isNotEmpty ? student.rollNumber : 'N/A'}'),
                          trailing: Switch(
                            value: isPresent,
                            onChanged: (value) {
                              if (student.id != null) {
                                setState(() {
                                  _attendance[student.id!] = value;
                                });
                              }
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                      );
                    } catch (e) {
                      print('Error creating student from document at index $index: $e');
                      return SizedBox.shrink(); // Return empty widget on error
                    }
                  },
                );
              },
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
      setState(() {
        _selectedDate = picked;
        _attendance.clear(); // Clear attendance when date changes
      });
    }
  }

  void _saveAttendance() async {
    if (_attendance.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please mark attendance for students'), 
          backgroundColor: Colors.orange
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    bool allSuccess = true;
    for (String studentId in _attendance.keys) {
      try {
        bool success = await _databaseService.markAttendance(
          studentId,
          _attendance[studentId]!,
          _selectedDate,
        );
        if (!success) allSuccess = false;
      } catch (e) {
        print('Error marking attendance for student $studentId: $e');
        allSuccess = false;
      }
    }

    // Hide loading indicator
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(allSuccess 
          ? 'Attendance saved successfully' 
          : 'Some attendance records failed to save'),
        backgroundColor: allSuccess ? Colors.green : Colors.orange,
      ),
    );

    if (allSuccess) {
      setState(() => _attendance.clear());
    }
  }
}
