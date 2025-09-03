// Database Service.Dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/student_model.dart';
import '../models/admin_model.dart';
import '../models/assignment_model.dart';
import '../models/announcement_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // STUDENT OPERATIONS

  // Create student
  Future<bool> createStudent(StudentModel student) async {
    try {
      await _firestore.collection('students').add(student.toFirestore());
      await _logActivity('Created student: ${student.studentName}');
      return true;
    } catch (e) {
      print('Create student error: $e');
      return false;
    }
  }

  // Get all students
  Stream<QuerySnapshot> getStudents() {
    return _firestore.collection('students').snapshots();
  }

  // Get students by year
  Stream<QuerySnapshot> getStudentsByYear(String year) {
    return _firestore
        .collection('students')
        .where('year', isEqualTo: year)
        .snapshots();
  }

  // Update student
  Future<bool> updateStudent(String studentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('students').doc(studentId).update(data);
      await _logActivity('Updated student: ${data['studentName'] ?? 'Unknown'}');
      return true;
    } catch (e) {
      print('Update student error: $e');
      return false;
    }
  }

  // Delete student
  Future<bool> deleteStudent(String studentId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('students').doc(studentId).get();
      String studentName = doc.get('studentName') ?? 'Unknown';
      
      await _firestore.collection('students').doc(studentId).delete();
      await _logActivity('Deleted student: $studentName');
      return true;
    } catch (e) {
      print('Delete student error: $e');
      return false;
    }
  }

  // ADMIN OPERATIONS

  // Create admin
  Future<bool> createAdmin(AdminModel admin) async {
    try {
      await _firestore.collection('admins').add(admin.toFirestore());
      await _logActivity('Created admin: ${admin.name}');
      return true;
    } catch (e) {
      print('Create admin error: $e');
      return false;
    }
  }

  // Get all admins
  Stream<QuerySnapshot> getAdmins() {
    return _firestore.collection('admins').snapshots();
  }

  // Update admin
  Future<bool> updateAdmin(String adminId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('admins').doc(adminId).update(data);
      await _logActivity('Updated admin: ${data['name'] ?? 'Unknown'}');
      return true;
    } catch (e) {
      print('Update admin error: $e');
      return false;
    }
  }

  // Delete admin
  Future<bool> deleteAdmin(String adminId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('admins').doc(adminId).get();
      String adminName = doc.get('name') ?? 'Unknown';
      
      await _firestore.collection('admins').doc(adminId).delete();
      await _logActivity('Deleted admin: $adminName');
      return true;
    } catch (e) {
      print('Delete admin error: $e');
      return false;
    }
  }

  // ASSIGNMENT OPERATIONS

  // Create assignment
  Future<bool> createAssignment(AssignmentModel assignment) async {
    try {
      await _firestore.collection('assignments').add(assignment.toFirestore());
      await _logActivity('Created assignment: ${assignment.title}');
      return true;
    } catch (e) {
      print('Create assignment error: $e');
      return false;
    }
  }

  // Get assignments
  Stream<QuerySnapshot> getAssignments() {
    return _firestore.collection('assignments').orderBy('dueDate', descending: false).snapshots();
  }

  // Get assignments by year
  Stream<QuerySnapshot> getAssignmentsByYear(String year) {
    return _firestore
        .collection('assignments')
        .where('year', isEqualTo: year)
        .orderBy('dueDate', descending: false)
        .snapshots();
  }

  // ANNOUNCEMENT OPERATIONS

  // Create announcement
  Future<bool> createAnnouncement(AnnouncementModel announcement) async {
    try {
      await _firestore.collection('announcements').add(announcement.toFirestore());
      await _logActivity('Created announcement: ${announcement.title}');
      return true;
    } catch (e) {
      print('Create announcement error: $e');
      return false;
    }
  }

  // Get announcements
  Stream<QuerySnapshot> getAnnouncements() {
    return _firestore
        .collection('announcements')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get announcements by year
  Stream<QuerySnapshot> getAnnouncementsByYear(String year) {
    return _firestore
        .collection('announcements')
        .where('year', isEqualTo: year)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ATTENDANCE OPERATIONS

  // Mark attendance
  Future<bool> markAttendance(String studentId, bool isPresent, DateTime date) async {
    try {
      Map<String, dynamic> attendanceData = {
        'studentId': studentId,
        'date': Timestamp.fromDate(date),
        'dateString': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'present': isPresent,
        'status': isPresent ? 'Present' : 'Absent',
      };

      await _firestore.collection('attendance').add(attendanceData);
      return true;
    } catch (e) {
      print('Mark attendance error: $e');
      return false;
    }
  }

  // Get attendance by date
  Stream<QuerySnapshot> getAttendanceByDate(DateTime date) {
    String dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _firestore
        .collection('attendance')
        .where('dateString', isEqualTo: dateString)
        .snapshots();
  }

  // QUERY OPERATIONS

  // Send query to superadmin
  Future<bool> sendQueryToSuperAdmin(String message) async {
    try {
      await _firestore.collection('queries').add({
        'message': message,
        'from': _auth.currentUser?.uid,
        'fromEmail': _auth.currentUser?.email,
        'to': 'superadmin',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      await _logActivity('Sent query to superadmin');
      return true;
    } catch (e) {
      print('Send query error: $e');
      return false;
    }
  }

  // Send query to admin
  Future<bool> sendQueryToAdmin(String message) async {
    try {
      await _firestore.collection('queries').add({
        'message': message,
        'from': _auth.currentUser?.uid,
        'fromEmail': _auth.currentUser?.email,
        'to': 'admin',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Send query to admin error: $e');
      return false;
    }
  }

  // Get queries
  Stream<QuerySnapshot> getQueries() {
    return _firestore
        .collection('queries')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // BATCH OPERATIONS

  // Create batch
  Future<bool> createBatch(String batchName) async {
    try {
      await _firestore.collection('batches').add({
        'name': batchName,
        'studentCount': 0,
        'createdBy': _auth.currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      await _logActivity('Created batch: $batchName');
      return true;
    } catch (e) {
      print('Create batch error: $e');
      return false;
    }
  }

  // Get batches
  Stream<QuerySnapshot> getBatches() {
    return _firestore.collection('batches').snapshots();
  }

  // ACTIVITY LOGGING

  Future<void> _logActivity(String action) async {
    try {
      await _firestore.collection('activities').add({
        'action': action,
        'createdBy': _auth.currentUser?.uid,
        'userEmail': _auth.currentUser?.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Log activity error: $e');
    }
  }

  // Get activities
  Stream<QuerySnapshot> getActivities() {
    return _firestore
        .collection('activities')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots();
  }

  // Get activities by user
  Stream<QuerySnapshot> getActivitiesByUser(String userId) {
    return _firestore
        .collection('activities')
        .where('createdBy', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
