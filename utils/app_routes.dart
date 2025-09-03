// App Routes.Dart
import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/auth_wrapper.dart';
import '../screens/superadmin/superadmin_dashboard.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/student/student_dashboard.dart';
import '../screens/common/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String authWrapper = '/auth';
  static const String superAdminDashboard = '/superadmin';
  static const String adminDashboard = '/admin';
  static const String studentDashboard = '/student';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case authWrapper:
        return MaterialPageRoute(builder: (_) => AuthWrapper());
      case superAdminDashboard:
        return MaterialPageRoute(builder: (_) => SuperAdminDashboard());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => AdminDashboard());
      case studentDashboard:
        return MaterialPageRoute(builder: (_) => StudentDashboard());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
