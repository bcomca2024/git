// Manage Assignments Screen.Dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database_service.dart';
import '../../models/assignment_model.dart';
import 'create_assignment_screen.dart';

class ManageAssignmentsScreen extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Assignments'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateAssignmentScreen()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _databaseService.getAssignments(),
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
                  Icon(Icons.assignment, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No assignments found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              AssignmentModel assignment = AssignmentModel.fromFirestore(snapshot.data!.docs[index]);
              
              bool isOverdue = assignment.dueDate.isBefore(DateTime.now());
              
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: Icon(
                    Icons.assignment,
                    color: isOverdue ? Colors.red : Colors.purple,
                  ),
                  title: Text(assignment.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Year ${assignment.year}'),
                      Text(
                        'Due: ${assignment.dueDate.day}/${assignment.dueDate.month}/${assignment.dueDate.year}',
                        style: TextStyle(
                          color: isOverdue ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: isOverdue 
                      ? Icon(Icons.warning, color: Colors.red)
                      : null,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(assignment.description),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Edit assignment
                                },
                                child: Text('Edit'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _showDeleteDialog(context, assignment.id!, assignment.title);
                                },
                                child: Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String assignmentId, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Assignment'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Delete assignment logic here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Assignment deleted'), backgroundColor: Colors.green),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
