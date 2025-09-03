// User Model.Dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // 'superadmin', 'admin', 'student'
  final String? adminNumber;
  final String? rollNumber;
  final String? year;
  final String? subject;
  final DateTime createdAt;
  final String? createdBy;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.adminNumber,
    this.rollNumber,
    this.year,
    this.subject,
    required this.createdAt,
    this.createdBy,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      adminNumber: data['adminNumber'],
      rollNumber: data['rollNumber'],
      year: data['year'],
      subject: data['subject'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'adminNumber': adminNumber,
      'rollNumber': rollNumber,
      'year': year,
      'subject': subject,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }
}
