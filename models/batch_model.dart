import 'package:cloud_firestore/cloud_firestore.dart';

class BatchModel {
  final String? id;
  final String batchName;
  final String year;
  final String subject;
  final List<String> studentIds;
  final DateTime createdAt;
  final String createdBy;

  BatchModel({
    this.id,
    required this.batchName,
    required this.year,
    required this.subject,
    required this.studentIds,
    required this.createdAt,
    required this.createdBy,
  });

  factory BatchModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BatchModel(
      id: doc.id,
      batchName: data['batchName'] ?? '',
      year: data['year'] ?? '',
      subject: data['subject'] ?? '',
      studentIds: List<String>.from(data['studentIds'] ?? []),
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'batchName': batchName,
      'year': year,
      'subject': subject,
      'studentIds': studentIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }
}
