// Admin Model.Dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String? id;
  final String name;
  final String email;
  final String adminNumber;
  final String password;
  final DateTime createdAt;
  final String createdBy;

  AdminModel({
    this.id,
    required this.name,
    required this.email,
    required this.adminNumber,
    required this.password,
    required this.createdAt,
    required this.createdBy,
  });

  factory AdminModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AdminModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      adminNumber: data['adminNumber'] ?? '',
      password: data['password'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'adminNumber': adminNumber,
      'password': password,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }
}
