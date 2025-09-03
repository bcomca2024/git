import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageBatchScreen extends StatefulWidget {
  @override
  _ManageBatchScreenState createState() => _ManageBatchScreenState();
}

class _ManageBatchScreenState extends State<ManageBatchScreen> {
  String _selectedYear = 'All';
  final List<String> _years = ['All', '1', '2', '3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Batches'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showCreateBatchDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Year Filter Section
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Icon(Icons.filter_list, color: Colors.purple),
                SizedBox(width: 8),
                Text('Filter by Year:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedYear,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _years.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year == 'All' ? 'All Years' : 'Year $year'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Batch List Section
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getBatchesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return _buildBatchCard(doc);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_work, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No Batches Found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Create your first batch by tapping the + button', style: TextStyle(color: Colors.grey[600])),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showCreateBatchDialog,
            icon: Icon(Icons.add),
            label: Text('Create Batch'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchCard(QueryDocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic> studentIds = data['studentIds'] ?? [];
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 4,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple,
          child: Text(
            data['batchName']?.toString().substring(0, 1).toUpperCase() ?? 'B',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(data['batchName'] ?? 'Unnamed Batch', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Year: ${data['year'] ?? 'N/A'} | Subject: ${data['subject'] ?? 'N/A'}'),
            Text('Students: ${studentIds.length}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _editBatch(doc);
            } else if (value == 'delete') {
              _deleteBatch(doc.id);
            } else if (value == 'manage_students') {
              _manageStudents(doc.id, data['batchName'], studentIds.cast<String>());
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'manage_students',
              child: ListTile(
                leading: Icon(Icons.people, size: 18, color: Colors.blue),
                title: Text('Manage Students'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit, size: 18),
                title: Text('Edit'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, size: 18, color: Colors.red),
                title: Text('Delete'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        children: [
          if (studentIds.isNotEmpty) _buildStudentsList(studentIds.cast<String>()),
          if (studentIds.isEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('No students in this batch', style: TextStyle(color: Colors.grey[600])),
            ),
        ],
      ),
    );
  }

  Widget _buildStudentsList(List<String> studentIds) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Students in this batch:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ...studentIds.map((studentId) => FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('students').doc(studentId).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var studentData = snapshot.data!.data() as Map<String, dynamic>;
                    return ListTile(
                      dense: true,
                      leading: Icon(Icons.person, size: 16),
                      title: Text(studentData['name'] ?? studentData['studentName'] ?? 'Unknown Student'),
                      subtitle: Text('Roll: ${studentData['rollNumber'] ?? 'N/A'}'),
                    );
                  }
                  return ListTile(
                    dense: true,
                    leading: Icon(Icons.person_outline, size: 16),
                    title: Text('Loading...'),
                  );
                },
              )),
        ],
      ),
    );
  }

  void _manageStudents(String batchId, String batchName, List<String> currentStudentIds) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageStudentsInBatchScreen(
          batchId: batchId,
          batchName: batchName,
          currentStudentIds: currentStudentIds,
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getBatchesStream() {
    if (_selectedYear == 'All') {
      return FirebaseFirestore.instance
          .collection('batches')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('batches')
          .where('year', isEqualTo: _selectedYear)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  void _showCreateBatchDialog() {
    showDialog(context: context, builder: (context) => CreateBatchDialog());
  }

  void _editBatch(QueryDocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    showDialog(
      context: context,
      builder: (context) => CreateBatchDialog(batchId: doc.id, initialData: data),
    );
  }

  void _deleteBatch(String batchId) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Batch'),
        content: Text('Are you sure you want to delete this batch? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance.collection('batches').doc(batchId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Batch deleted successfully'), backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting batch: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
