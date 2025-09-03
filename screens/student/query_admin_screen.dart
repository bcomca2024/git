// Query Admin Screen.Dart
import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../utils/validators.dart';

class QueryAdminScreen extends StatefulWidget {
  @override
  _QueryAdminScreenState createState() => _QueryAdminScreenState();
}

class _QueryAdminScreenState extends State<QueryAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Query Admin'),
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
                  Text('Send Query to Admin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    'Use this form to ask questions about your academics, attendance, or any other concerns.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Your Query',
                      prefixIcon: Icon(Icons.message),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      hintText: 'Enter your question or concern here...',
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
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.green),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your query will be sent to the admin team. You can expect a response within 24-48 hours.',
                            style: TextStyle(color: Colors.green[800]),
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
      bool success = await _databaseService.sendQueryToAdmin(_messageController.text.trim());
      
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
