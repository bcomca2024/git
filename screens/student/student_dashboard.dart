// Student Dashboard.Dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import 'view_announcements_screen.dart';
import 'view_assignments_screen.dart';
import 'view_attendance_screen.dart';
import 'student_profile_screen.dart';
import '../../services/auth_service.dart';


class StudentDashboard extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              'My Profile',
              Icons.person,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentProfileScreen()),
              ),
            ),
            _buildDashboardCard(
              'Announcements',
              Icons.announcement,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewAnnouncementsScreen()),
              ),
            ),
            _buildDashboardCard(
              'Assignments',
              Icons.assignment,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewAssignmentsScreen()),
              ),
            ),
            _buildDashboardCard(
              'My Attendance',
              Icons.how_to_reg,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewAttendanceScreen()),
              ),
            ),
            _buildDashboardCard(
              'Materials',
              Icons.book,
              Colors.red,
              () {
                // Navigate to materials
              },
            ),
            _buildDashboardCard(
              'Query Admin',
              Icons.help,
              Colors.teal,
              () {
                // Navigate to query admin
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    await _authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
