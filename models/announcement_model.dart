// Announcement Model.Dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  final String? id;
  final String title;
  final String message;
  final DateTime createdAt;
  final String year;

  AnnouncementModel({
    this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.year,
  });

  factory AnnouncementModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AnnouncementModel(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      year: data['year'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'year': year,
    };
  }
}
