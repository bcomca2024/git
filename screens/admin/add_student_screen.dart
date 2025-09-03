// Add Student Screen.Dart
import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/student_model.dart';
import '../../utils/validators.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _studentIdController = TextEditingController();
  
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;
  String _selectedYear = '1';
  String _selectedSubject = 'Computer Science';

  final List<String> _years = ['1', '2', '3'];
  final List<String> _subjects = [
    'Computer Science',
    'Mathematics', 
    'Physics',
    'Chemistry',
    'English',
    'Business Studies'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Student Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Student Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: Validators.validateName,
                      ),
                      SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                      ),
                      SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _rollNumberController,
                        decoration: InputDecoration(
                          labelText: 'Roll Number',
                          prefixIcon: Icon(Icons.badge),
                          border: OutlineInputBorder(),
                        ),
                        validator: Validators.validateRollNumber,
                      ),
                      SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _studentIdController,
                        decoration: InputDecoration(
                          labelText: 'Student ID',
                          prefixIcon: Icon(Icons.fingerprint),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Please enter student ID';
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      
                      // Year Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedYear,
                        decoration: InputDecoration(
                          labelText: 'Year',
                          prefixIcon: Icon(Icons.school),
                          border: OutlineInputBorder(),
                        ),
                        items: _years.map((year) {
                          return DropdownMenuItem(value: year, child: Text('Year $year'));
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedYear = value!),
                        validator: (value) => value == null ? 'Please select year' : null,
                      ),
                      SizedBox(height: 16),
                      
                      // Subject Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedSubject,
                        decoration: InputDecoration(
                          labelText: 'Subject',
                          prefixIcon: Icon(Icons.book),
                          border: OutlineInputBorder(),
                        ),
                        items: _subjects.map((subject) {
                          return DropdownMenuItem(value: subject, child: Text(subject));
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedSubject = value!),
                        validator: (value) => value == null ? 'Please select subject' : null,
                      ),
                      SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _addStudent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('Add Student'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      DateTime now = DateTime.now();
      StudentModel student = StudentModel(
        studentName: _nameController.text.trim(),
        studentEmail: _emailController.text.trim(),
        studentId: _studentIdController.text.trim(),
        rollNumber: _rollNumberController.text.trim(),
        year: _selectedYear,
        subject: _selectedSubject,
        date: now,
        dateString: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        present: false,
        status: 'Absent',
      );

      bool success = await _databaseService.createStudent(student);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student added successfully'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to add student');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _rollNumberController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }
}
