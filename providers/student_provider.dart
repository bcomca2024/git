// Student Provider.Dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_service.dart';
import '../models/student_model.dart';

class StudentProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  List<StudentModel> _students = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedYear = 'All';

  List<StudentModel> get students => _students;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedYear => _selectedYear;

  Stream<QuerySnapshot> get studentsStream => _selectedYear == 'All'
      ? _databaseService.getStudents()
      : _databaseService.getStudentsByYear(_selectedYear);

  void setSelectedYear(String year) {
    _selectedYear = year;
    notifyListeners();
  }

  Future<bool> addStudent(StudentModel student) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool success = await _databaseService.createStudent(student);
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStudent(String studentId, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool success = await _databaseService.updateStudent(studentId, data);
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteStudent(String studentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool success = await _databaseService.deleteStudent(studentId);
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
