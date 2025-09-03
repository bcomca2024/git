// Assignment Model.Dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentModel {
  final String? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime uploadedAt;
  final String year;

  AssignmentModel({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.uploadedAt,
    required this.year,
  });

  factory AssignmentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AssignmentModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      uploadedAt: (data['uploadedAt'] as Timestamp).toDate(),
      year: data['year'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'year': year,
    };
  }
}
