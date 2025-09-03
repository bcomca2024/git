// Admin Dashboard.Dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import 'manage_students_screen.dart';
import 'manage_announcements_screen.dart';
import 'manage_assignments_screen.dart';
import 'attendance_screen.dart';
import 'manage_batch_screen.dart';  // ADD THIS IMPORT

class AdminDashboard extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.green,
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
              'Manage Students',
              Icons.people,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageStudentsScreen()),
              ),
            ),
            _buildDashboardCard(
              'Attendance',
              Icons.how_to_reg,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AttendanceScreen()),
              ),
            ),
            _buildDashboardCard(
              'Announcements',
              Icons.announcement,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageAnnouncementsScreen()),
              ),
            ),
            _buildDashboardCard(
              'Assignments',
              Icons.assignment,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageAssignmentsScreen()),
              ),
            ),
            _buildDashboardCard(
              'Create Batch',
              Icons.group_add,
              Colors.red,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageBatchScreen()),
              ),
            ),
            _buildDashboardCard(
              'Query SuperAdmin',
              Icons.help,
              Colors.teal,
              () {
                // Navigate to query superadmin
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Query SuperAdmin feature coming soon!')),
                );
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
