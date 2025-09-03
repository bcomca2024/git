// Date Helper.Dart
import 'package:intl/intl.dart';

class DateHelper {
  // Date Formatters
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
  static final DateFormat _displayDateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _displayDateTimeFormat = DateFormat('dd MMM yyyy, HH:mm');

  // Format date to string
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  // Format time to string
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  // Format datetime to string
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  // Format date for display
  static String formatDisplayDate(DateTime date) {
    return _displayDateFormat.format(date);
  }

  // Format datetime for display
  static String formatDisplayDateTime(DateTime date) {
    return _displayDateTimeFormat.format(date);
  }

  // Parse date from string
  static DateTime? parseDate(String dateString) {
    try {
      return _dateFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Parse datetime from string
  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return _dateTimeFormat.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  // Get today's date string
  static String getTodayString() {
    return formatDate(DateTime.now());
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(Duration(days: 6));
    
    return date.isAfter(weekStart.subtract(Duration(days: 1))) && 
           date.isBefore(weekEnd.add(Duration(days: 1)));
  }

  // Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatDisplayDate(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Calculate age from birthdate
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }
}
