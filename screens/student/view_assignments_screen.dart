// View Assignments Screen.Dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database_service.dart';
import '../../models/assignment_model.dart';

class ViewAssignmentsScreen extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
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
                  Text('No assignments available', style: TextStyle(fontSize: 18, color: Colors.grey)),
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
                child: ListTile(
                  leading: Icon(
                    Icons.assignment,
                    color: isOverdue ? Colors.red : Colors.purple,
                  ),
                  title: Text(assignment.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(assignment.description),
                      SizedBox(height: 4),
                      Text(
                        'Due: ${assignment.dueDate.day}/${assignment.dueDate.month}/${assignment.dueDate.year}',
                        style: TextStyle(
                          color: isOverdue ? Colors.red : Colors.grey,
                          fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  trailing: isOverdue 
                      ? Chip(
                          label: Text('Overdue', style: TextStyle(color: Colors.white, fontSize: 12)),
                          backgroundColor: Colors.red,
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
