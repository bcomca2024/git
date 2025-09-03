// Query Model.Dart
import 'package:cloud_firestore/cloud_firestore.dart';

class QueryModel {
  final String? id;
  final String message;
  final String from;
  final String fromEmail;
  final String to;
  final String status; // 'pending', 'resolved', 'closed'
  final DateTime createdAt;
  final String? response;
  final DateTime? responseAt;

  QueryModel({
    this.id,
    required this.message,
    required this.from,
    required this.fromEmail,
    required this.to,
    required this.status,
    required this.createdAt,
    this.response,
    this.responseAt,
  });

  factory QueryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return QueryModel(
      id: doc.id,
      message: data['message'] ?? '',
      from: data['from'] ?? '',
      fromEmail: data['fromEmail'] ?? '',
      to: data['to'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      response: data['response'],
      responseAt: data['responseAt'] != null ? (data['responseAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'message': message,
      'from': from,
      'fromEmail': fromEmail,
      'to': to,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'response': response,
      'responseAt': responseAt != null ? Timestamp.fromDate(responseAt!) : null,
    };
  }
}
