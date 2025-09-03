// Create Batch Screen.Dart
import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../utils/validators.dart';

class CreateBatchScreen extends StatefulWidget {
  @override
  _CreateBatchScreenState createState() => _CreateBatchScreenState();
}

class _CreateBatchScreenState extends State<CreateBatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _batchNameController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Batch'),
        backgroundColor: Colors.red,
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
                  Text('New Batch', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _batchNameController,
                    decoration: InputDecoration(
                      labelText: 'Batch Name (e.g., 2025-2026)',
                      prefixIcon: Icon(Icons.group),
                      border: OutlineInputBorder(),
                      hintText: 'Enter batch name like 2025-2026',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter batch name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Batch Information:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('• A batch represents an academic year'),
                        Text('• Students can be assigned to specific batches'),
                        Text('• Use format: YYYY-YYYY (e.g., 2025-2026)'),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createBatch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Create Batch'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createBatch() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      bool success = await _databaseService.createBatch(_batchNameController.text.trim());
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Batch created successfully'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to create batch');
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
    _batchNameController.dispose();
    super.dispose();
  }
}
