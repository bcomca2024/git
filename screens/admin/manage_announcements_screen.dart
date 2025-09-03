// Manage Announcements Screen.Dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database_service.dart';
import '../../models/announcement_model.dart';
import 'create_announcement_screen.dart';

class ManageAnnouncementsScreen extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Announcements'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateAnnouncementScreen()),
            ),
          ),
        ],
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
                  Text('No announcements found', style: TextStyle(fontSize: 18, color: Colors.grey)),
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
                    'Year ${announcement.year} • ${announcement.createdAt.day}/${announcement.createdAt.month}/${announcement.createdAt.year}',
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement.message,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Edit announcement
                                },
                                child: Text('Edit'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _showDeleteDialog(context, announcement.id!, announcement.title);
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

  void _showDeleteDialog(BuildContext context, String announcementId, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Announcement'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Delete announcement logic here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Announcement deleted'), backgroundColor: Colors.green),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
