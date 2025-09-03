// View Announcements Screen.Dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database_service.dart';
import '../../models/announcement_model.dart';

class ViewAnnouncementsScreen extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _databaseService.getAnnouncements(),
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
                  Icon(Icons.announcement, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No announcements available', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              AnnouncementModel announcement = AnnouncementModel.fromFirestore(snapshot.data!.docs[index]);
              
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: Icon(Icons.announcement, color: Colors.orange),
                  title: Text(announcement.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${announcement.createdAt.day}/${announcement.createdAt.month}/${announcement.createdAt.year}',
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        announcement.message,
                        style: TextStyle(fontSize: 16),
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
}
