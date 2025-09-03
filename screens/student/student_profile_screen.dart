// Student Profile Screen.Dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';


class StudentProfileScreen extends StatefulWidget {
  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      User? currentUser = _authService.currentUser;
      if (currentUser != null) {
        UserModel? userData = await _authService.getUserData(currentUser.uid);
        setState(() {
          _user = userData;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        body: Center(child: Text('Unable to load profile data')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.purple,
                      child: Text(
                        _user!.name[0].toUpperCase(),
                        style: TextStyle(fontSize: 36, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _user!.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _user!.email,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Chip(
                      label: Text('Student'),
                      backgroundColor: Colors.purple[100],
                      labelStyle: TextStyle(color: Colors.purple[800]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Profile Details
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Profile Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    
                    _buildInfoRow('Roll Number', _user!.rollNumber ?? 'N/A'),
                    _buildInfoRow('Year', _user!.year ?? 'N/A'),
                    _buildInfoRow('Subject', _user!.subject ?? 'N/A'),
                    _buildInfoRow('Email', _user!.email),
                    _buildInfoRow('Member Since', '${_user!.createdAt.day}/${_user!.createdAt.month}/${_user!.createdAt.year}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Quick Actions
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    
                    ListTile(
                      leading: Icon(Icons.assignment, color: Colors.purple),
                      title: Text('View Assignments'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to assignments
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.announcement, color: Colors.orange),
                      title: Text('View Announcements'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to announcements
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.how_to_reg, color: Colors.green),
                      title: Text('Check Attendance'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to attendance
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
