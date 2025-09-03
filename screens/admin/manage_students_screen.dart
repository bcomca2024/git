// Manage Students Screen.Dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database_service.dart';
import '../../models/student_model.dart';
import 'add_student_screen.dart';
import 'edit_student_screen.dart';

class ManageStudentsScreen extends StatefulWidget {
  @override
  _ManageStudentsScreenState createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  final DatabaseService _databaseService = DatabaseService();
  String _selectedYear = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Students'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddStudentScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Year Filter
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text('Filter by Year: ', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedYear,
                  items: ['All', '1', '2', '3'].map((year) {
                    return DropdownMenuItem(value: year, child: Text('Year $year'));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedYear = value!);
                  },
                ),
              ],
            ),
          ),
          
          // Students List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _selectedYear == 'All' 
                  ? _databaseService.getStudents()
                  : _databaseService.getStudentsByYear(_selectedYear),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No students found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    StudentModel student = StudentModel.fromFirestore(snapshot.data!.docs[index]);
                    
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(student.studentName[0].toUpperCase()),
                        ),
                        title: Text(student.studentName, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(student.studentEmail),
                            Text('Roll: ${student.rollNumber} | Year: ${student.year}', 
                                 style: TextStyle(fontSize: 12)),
                            Text('Subject: ${student.subject}', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 16),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 16, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditStudentScreen(student: student),
                                ),
                              );
                            } else if (value == 'delete') {
                              _showDeleteDialog(context, student.id!, student.studentName);
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String studentId, String studentName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Student'),
        content: Text('Are you sure you want to delete $studentName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              bool success = await _databaseService.deleteStudent(studentId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? 'Student deleted successfully' : 'Failed to delete student'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
