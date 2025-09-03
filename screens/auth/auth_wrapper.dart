import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../superadmin/superadmin_dashboard.dart';
import '../admin/admin_dashboard.dart';
import '../student/student_dashboard.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }

        // If user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<String?>(
            future: _authService.getUserRole(snapshot.data!.uid),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingScreen();
              }

              // Navigate based on user role
              if (roleSnapshot.hasData) {
                switch (roleSnapshot.data) {
                  case 'superadmin':
                    return SuperAdminDashboard();
                  case 'admin':
                    return AdminDashboard();
                  case 'student':
                    return StudentDashboard();
                  default:
                    return LoginScreen();
                }
              }
              return LoginScreen();
            },
          );
        }

        // If no user is logged in
        return LoginScreen();
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'BCOMCA Student Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
