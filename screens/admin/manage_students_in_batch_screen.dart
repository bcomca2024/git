import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageStudentsInBatchScreen extends StatefulWidget {
  final String batchId;
  final String batchName;
  final List<String> currentStudentIds;

  const ManageStudentsInBatchScreen({
    Key? key,
    required this.batchId,
    required this.batchName,
    required this.currentStudentIds,
  }) : super(key: key);

  @override
  _ManageStudentsInBatchScreenState createState() => _ManageStudentsInBatchScreenState();
}

class _ManageStudentsInBatchScreenState extends State<ManageStudentsInBatchScreen> {
  List<String> availableStudents = [];
  List<String> batchStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() async {
    try {
      QuerySnapshot allStudentsSnapshot = await FirebaseFirestore.instance.collection('students').get();
      
      batchStudents = List.from(widget.currentStudentIds);
      availableStudents = allStudentsSnapshot.docs
          .map((doc) => doc.id)
          .where((studentId) => !batchStudents.contains(studentId))
          .toList();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading students: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Manage Students')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Students in ${widget.batchName}'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.people_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Available Students (${availableStudents.length})', 
                             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: availableStudents.isEmpty
                        ? Center(child: Text('All students are assigned to batches'))
                        : ListView.builder(
                            itemCount: availableStudents.length,
                            itemBuilder: (context, index) {
                              return _buildStudentCard(
                                availableStudents[index],
                                false,
                                () => _moveStudentToBatch(index),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            Container(
              width: 2,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.group, color: Colors.purple),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text('Students in ${widget.batchName} (${batchStudents.length})',
                                     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: batchStudents.isEmpty
                        ? Center(child: Text('No students in this batch'))
                        : ListView.builder(
                            itemCount: batchStudents.length,
                            itemBuilder: (context, index) {
                              return _buildStudentCard(
                                batchStudents[index],
                                true,
                                () => _removeStudentFromBatch(index),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(String studentId, bool inBatch, VoidCallback onMove) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('students').doc(studentId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return SizedBox.shrink();
        }

        var studentData = snapshot.data!.data() as Map<String, dynamic>;
        String studentName = studentData['name'] ?? studentData['studentName'] ?? 'Unknown Student';
        String rollNumber = studentData['rollNumber'] ?? 'N/A';
        String year = studentData['year'] ?? 'N/A';

        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: inBatch ? Colors.purple[100] : Colors.blue[100],
              child: Text(
                studentName[0].toUpperCase(),
                style: TextStyle(
                  color: inBatch ? Colors.purple : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(studentName),
            subtitle: Text('Roll: $rollNumber | Year: $year'),
            trailing: IconButton(
              icon: Icon(
                inBatch ? Icons.arrow_back : Icons.arrow_forward,
                color: inBatch ? Colors.red : Colors.green,
              ),
              onPressed: onMove,
            ),
          ),
        );
      },
    );
  }

  void _moveStudentToBatch(int index) {
    setState(() {
      String studentId = availableStudents.removeAt(index);
      batchStudents.add(studentId);
    });
  }

  void _removeStudentFromBatch(int index) {
    setState(() {
      String studentId = batchStudents.removeAt(index);
      availableStudents.add(studentId);
    });
  }

  void _saveChanges() async {
    try {
      await FirebaseFirestore.instance.collection('batches').doc(widget.batchId).update({
        'studentIds': batchStudents,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes saved successfully'), backgroundColor: Colors.green),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving changes: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
