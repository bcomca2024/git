// Constants.Dart
class AppConstants {
  // App Info
  static const String appName = 'BCOMCA Student Management';
  static const String appVersion = '1.0.0';

  // User Roles
  static const String superAdminRole = 'superadmin';
  static const String adminRole = 'admin';
  static const String studentRole = 'student';

  // Collection Names
  static const String usersCollection = 'users';
  static const String studentsCollection = 'students';
  static const String adminsCollection = 'admins';
  static const String assignmentsCollection = 'assignments';
  static const String announcementsCollection = 'announcements';
  static const String attendanceCollection = 'attendance';
  static const String batchesCollection = 'batches';
  static const String queriesCollection = 'queries';
  static const String activitiesCollection = 'activities';
  static const String materialsCollection = 'materials';
  static const String subjectsCollection = 'subjects';
  static const String teachersCollection = 'teachers';

  // Default Values
  static const String defaultYear = '1';
  static const String defaultSubject = 'All';
  static const int maxStudentsPerBatch = 60;
  static const int maxAnnouncementLength = 500;
  static const int maxQueryLength = 1000;

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;
}
