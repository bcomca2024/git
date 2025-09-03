// System Settings Screen.Dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../../services/auth_service.dart';


class SystemSettingsScreen extends StatefulWidget {
  @override
  _SystemSettingsScreenState createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('System Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.backup, color: Colors.green),
                  title: Text('Backup Database'),
                  subtitle: Text('Create a backup of all data'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _showBackupDialog(),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.restore, color: Colors.orange),
                  title: Text('Restore Database'),
                  subtitle: Text('Restore from a previous backup'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _showRestoreDialog(),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.security, color: Colors.red),
                  title: Text('Security Settings'),
                  subtitle: Text('Configure security options'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to security settings
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.purple),
                  title: Text('Notification Settings'),
                  subtitle: Text('Manage system notifications'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to notification settings
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info, color: Colors.blue),
                  title: Text('System Information'),
                  subtitle: Text('View system details'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _showSystemInfo(),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.help, color: Colors.teal),
                  title: Text('Help & Support'),
                  subtitle: Text('Get help and support'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to help
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          
          ElevatedButton(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Backup Database'),
        content: Text('This will create a backup of all system data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Backup started...'), backgroundColor: Colors.green),
              );
            },
            child: Text('Backup'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restore Database'),
        content: Text('This will restore data from a backup. All current data will be replaced. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Restore started...'), backgroundColor: Colors.orange),
              );
            },
            child: Text('Restore', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSystemInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('System Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Version: 1.0.0'),
            Text('Flutter Version: 3.13.0'),
            Text('Firebase SDK: 12.0.0'),
            Text('Platform: Web/Mobile'),
            Text('Build: Production'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    await _authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
