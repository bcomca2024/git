import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database_service.dart';
import '../../models/student_model.dart';
import '../../utils/validators.dart';

class EditStudentScreen extends StatefulWidget {
  final StudentModel student;

  const EditStudentScreen({Key? key, required this.student}) : super(key: key);

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _rollNumberController;
  late TextEditingController _studentIdController;
  
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;
  late String _selectedYear;
  late String _selectedSubject;
  String? _selectedBatchId;
  String? _selectedBatchName;

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
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.studentName);
    _emailController = TextEditingController(text: widget.student.studentEmail);
    _rollNumberController = TextEditingController(text: widget.student.rollNumber);
    _studentIdController = TextEditingController(text: widget.student.studentId);
    
    // Safe initialization with fallback values
    _selectedYear = _years.contains(widget.student.year) ? widget.student.year : _years.first;
    _selectedSubject = _subjects.contains(widget.student.subject) ? widget.student.subject : _subjects.first;
    
    _loadStudentBatch();
  }

  void _loadStudentBatch() async {
    try {
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.student.id)
          .get();
      
      if (studentDoc.exists) {
        var data = studentDoc.data() as Map<String, dynamic>;
        setState(() {
          _selectedBatchId = data['batchId'];
          _selectedBatchName = data['batchName'];
        });
      }
    } catch (e) {
      print('Error loading student batch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Edit Student Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                  
                  // Fixed Year Dropdown
                  DropdownButtonFormField<String>(
                    value: _years.contains(_selectedYear) ? _selectedYear : _years.first,
                    decoration: InputDecoration(
                      labelText: 'Year',
                      prefixIcon: Icon(Icons.school),
                      border: OutlineInputBorder(),
                    ),
                    items: _years.map((year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text('Year $year'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value!;
                        _selectedBatchId = null; // Reset batch when year changes
                        _selectedBatchName = null;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  
                  // Fixed Subject Dropdown
                  DropdownButtonFormField<String>(
                    value: _subjects.contains(_selectedSubject) ? _selectedSubject : _subjects.first,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      prefixIcon: Icon(Icons.book),
                      border: OutlineInputBorder(),
                    ),
                    items: _subjects.map((subject) {
                      return DropdownMenuItem<String>(
                        value: subject, 
                        child: Text(subject)
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubject = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Batch Selection
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('batches')
                        .where('year', isEqualTo: _selectedYear)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }

                      List<DropdownMenuItem<String>> batchItems = [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text('No Batch Assigned'),
                        ),
                      ];

                      for (var doc in snapshot.data!.docs) {
                        var data = doc.data() as Map<String, dynamic>;
                        batchItems.add(
                          DropdownMenuItem<String>(
                            value: doc.id,
                            child: Text('${data['batchName']} (${data['subject']})'),
                          ),
                        );
                      }

                      return DropdownButtonFormField<String>(
                        value: batchItems.any((item) => item.value == _selectedBatchId) ? _selectedBatchId : null,
                        decoration: InputDecoration(
                          labelText: 'Assign to Batch',
                          prefixIcon: Icon(Icons.group),
                          border: OutlineInputBorder(),
                        ),
                        items: batchItems,
                        onChanged: (value) {
                          setState(() {
                            _selectedBatchId = value;
                            if (value != null) {
                              // Find batch name
                              var selectedBatch = snapshot.data!.docs.firstWhere((doc) => doc.id == value);
                              var batchData = selectedBatch.data() as Map<String, dynamic>;
                              _selectedBatchName = batchData['batchName'];
                            } else {
                              _selectedBatchName = null;
                            }
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updateStudent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('Update'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> updateData = {
        'studentName': _nameController.text.trim(),
        'studentEmail': _emailController.text.trim(),
        'rollNumber': _rollNumberController.text.trim(),
        'studentId': _studentIdController.text.trim(),
        'year': _selectedYear,
        'subject': _selectedSubject,
        'batchId': _selectedBatchId,
        'batchName': _selectedBatchName,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      bool success = await _databaseService.updateStudent(widget.student.id!, updateData);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student updated successfully'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to update student');
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
