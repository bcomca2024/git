// Query Superadmin Screen.Dart
import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../utils/validators.dart';

class QuerySuperAdminScreen extends StatefulWidget {
  @override
  _QuerySuperAdminScreenState createState() => _QuerySuperAdminScreenState();
}

class _QuerySuperAdminScreenState extends State<QuerySuperAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Query SuperAdmin'),
        backgroundColor: Colors.teal,
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
                  Text('Send Query to SuperAdmin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    'Use this form to send questions, requests, or reports to the SuperAdmin.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Your Message',
                      prefixIcon: Icon(Icons.message),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      hintText: 'Enter your query, request, or question here...',
                    ),
                    maxLines: 8,
                    validator: Validators.validateMessage,
                  ),
                  SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendQuery,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Send Query'),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your query will be sent directly to the SuperAdmin and you will receive a response as soon as possible.',
                            style: TextStyle(color: Colors.blue[800]),
                          ),
                        ),
                      ],
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

  void _sendQuery() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      bool success = await _databaseService.sendQueryToSuperAdmin(_messageController.text.trim());
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Query sent successfully'), backgroundColor: Colors.green),
        );
        _messageController.clear();
      } else {
        throw Exception('Failed to send query');
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
    _messageController.dispose();
    super.dispose();
  }
}
