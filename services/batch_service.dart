import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/batch_model.dart';

class BatchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new batch
  Future<bool> createBatch(BatchModel batch) async {
    try {
      await _firestore.collection('batches').add(batch.toFirestore());
      return true;
    } catch (e) {
      print('Error creating batch: $e');
      return false;
    }
  }

  // Get all batches
  Stream<QuerySnapshot> getBatches() {
    return _firestore.collection('batches')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get batches by year
  Stream<QuerySnapshot> getBatchesByYear(String year) {
    return _firestore.collection('batches')
        .where('year', isEqualTo: year)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Batch update multiple students
  Future<bool> batchUpdateStudents(Map<String, Map<String, dynamic>> updates) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      updates.forEach((docId, data) {
        DocumentReference docRef = _firestore.collection('students').doc(docId);
        batch.update(docRef, data);
      });
      
      await batch.commit();
      print('Batch update successful: ${updates.length} students updated');
      return true;
    } catch (e) {
      print('Batch update failed: $e');
      return false;
    }
  }

  // Promote students to next year (batch operation)
  Future<bool> promoteStudents(List<String> studentIds, String newYear) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      for (String studentId in studentIds) {
        DocumentReference docRef = _firestore.collection('students').doc(studentId);
        batch.update(docRef, {
          'year': newYear,
          'promoted': true,
          'promotionDate': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
      print('${studentIds.length} students promoted to year $newYear');
      return true;
    } catch (e) {
      print('Batch promotion failed: $e');
      return false;
    }
  }

  // Assign subject to multiple students
  Future<bool> assignSubjectToStudents(List<String> studentIds, String subject) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      for (String studentId in studentIds) {
        DocumentReference docRef = _firestore.collection('students').doc(studentId);
        batch.update(docRef, {
          'subject': subject,
          'subjectAssignedAt': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
      return true;
    } catch (e) {
      print('Subject assignment failed: $e');
      return false;
    }
  }

  // Delete multiple students (batch operation)
  Future<bool> deleteStudentsBatch(List<String> studentIds) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      for (String studentId in studentIds) {
        DocumentReference docRef = _firestore.collection('students').doc(studentId);
        batch.delete(docRef);
      }
      
      await batch.commit();
      return true;
    } catch (e) {
      print('Batch delete failed: $e');
      return false;
    }
  }

  // Update batch
  Future<bool> updateBatch(String batchId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('batches').doc(batchId).update(data);
      return true;
    } catch (e) {
      print('Error updating batch: $e');
      return false;
    }
  }

  // Delete batch
  Future<bool> deleteBatch(String batchId) async {
    try {
      await _firestore.collection('batches').doc(batchId).delete();
      return true;
    } catch (e) {
      print('Error deleting batch: $e');
      return false;
    }
  }
}
