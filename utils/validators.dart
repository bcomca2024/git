// Validators.Dart
class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    if (value.length > 50) {
      return 'Name cannot be longer than 50 characters';
    }
    
    final nameRegex = RegExp(r"^[a-zA-Z\s]+$");
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    
    return null;
  }

  // Roll number validation
  static String? validateRollNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a roll number';
    }
    
    if (value.length < 3) {
      return 'Roll number must be at least 3 characters long';
    }
    
    return null;
  }

  // Admin number validation
  static String? validateAdminNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an admin number';
    }
    
    if (value.length < 3) {
      return 'Admin number must be at least 3 characters long';
    }
    
    return null;
  }

  // Year validation
  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a year';
    }
    
    final validYears = ['1', '2', '3'];
    if (!validYears.contains(value)) {
      return 'Please select a valid year (1, 2, or 3)';
    }
    
    return null;
  }

  // Subject validation
  static String? validateSubject(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a subject';
    }
    
    return null;
  }

  // Title validation (for assignments, announcements)
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    
    if (value.length < 3) {
      return 'Title must be at least 3 characters long';
    }
    
    if (value.length > 100) {
      return 'Title cannot be longer than 100 characters';
    }
    
    return null;
  }

  // Description validation
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    
    if (value.length < 10) {
      return 'Description must be at least 10 characters long';
    }
    
    if (value.length > 1000) {
      return 'Description cannot be longer than 1000 characters';
    }
    
    return null;
  }

  // Message validation (for queries)
  static String? validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a message';
    }
    
    if (value.length < 10) {
      return 'Message must be at least 10 characters long';
    }
    
    if (value.length > 1000) {
      return 'Message cannot be longer than 1000 characters';
    }
    
    return null;
  }
}
