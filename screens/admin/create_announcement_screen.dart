// Create Announcement Screen.Dart
import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/announcement_model.dart';
import '../../utils/validators.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  @override
  _CreateAnnouncementScreenState createState() => _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;
  String _selectedYear = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Announcement'),
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
                  Text('New Announcement', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                    ),
                    validator: Validators.validateTitle,
                  ),
                  SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    value: _selectedYear,
                    decoration: InputDecoration(
                      labelText: 'Target Year',
                      prefixIcon: Icon(Icons.school),
                      border: OutlineInputBorder(),
                    ),
                    items: ['1', '2', '3', 'All'].map((year) {
                      return DropdownMenuItem(value: year, child: Text(year == 'All' ? 'All Years' : 'Year $year'));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedYear = value!),
                  ),
                  SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      prefixIcon: Icon(Icons.message),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please enter a message';
                      if (value!.length < 10) return 'Message must be at least 10 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createAnnouncement,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Create Announcement'),
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

  void _createAnnouncement() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      AnnouncementModel announcement = AnnouncementModel(
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        year: _selectedYear,
        createdAt: DateTime.now(),
      );

      bool success = await _databaseService.createAnnouncement(announcement);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Announcement created successfully'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to create announcement');
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
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
