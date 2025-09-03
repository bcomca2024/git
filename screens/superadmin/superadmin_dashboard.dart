// Superadmin Dashboard.Dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import 'manage_admins_screen.dart';
import 'admin_activities_screen.dart';
import 'system_settings_screen.dart';
import '../../services/auth_service.dart';


class SuperAdminDashboard extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SuperAdmin Dashboard'),
        backgroundColor: Colors.blue,
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
              'Manage Admins',
              Icons.admin_panel_settings,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageAdminsScreen()),
              ),
            ),
            _buildDashboardCard(
              'Admin Activities',
              Icons.history,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminActivitiesScreen()),
              ),
            ),
            _buildDashboardCard(
              'System Settings',
              Icons.settings,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SystemSettingsScreen()),
              ),
            ),
            _buildDashboardCard(
              'All Students',
              Icons.people,
              Colors.purple,
              () {
                // Navigate to view all students
              },
            ),
            _buildDashboardCard(
              'Reports',
              Icons.analytics,
              Colors.red,
              () {
                // Navigate to reports
              },
            ),
            _buildDashboardCard(
              'Backup & Restore',
              Icons.backup,
              Colors.teal,
              () {
                // Navigate to backup
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
