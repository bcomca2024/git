import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Create user account
  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String role, {
    String? adminNumber,
    String? rollNumber,
    String? year,
    String? subject,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document
      UserModel user = UserModel(
        uid: result.user!.uid,
        name: name,
        email: email,
        role: role,
        adminNumber: adminNumber,
        rollNumber: rollNumber,
        year: year,
        subject: subject,
        createdAt: DateTime.now(),
        createdBy: currentUser?.uid,
      );

      await _firestore
          .collection('users')
          .doc(result.user!.uid)
          .set(user.toFirestore());

      return result;
    } catch (e) {
      print('Create user error: $e');
      return null;
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  // Get user role
 Future<String?> getUserRole(String uid) async {
  try {
    DocumentSnapshot doc = await _firestore.collection('students').doc(uid).get();
    
    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print('User data found: $data'); // Debug print
      return data['role'] as String?;
    }
    
    print('Document does not exist for UID: $uid');
    return null;
  } catch (e) {
    print('Error fetching user role: $e');
    return null;
  }
}


  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }
}
