import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String? id;
  final String studentName;
  final String studentEmail;
  final String studentId;
  final String rollNumber;
  final String year;
  final String subject;
  final DateTime? date;  // Made nullable
  final String dateString;
  final bool present;
  final String status;

  StudentModel({
    this.id,
    required this.studentName,
    required this.studentEmail,
    required this.studentId,
    required this.rollNumber,
    required this.year,
    required this.subject,
    this.date,  // Made optional
    required this.dateString,
    required this.present,
    required this.status,
  });

  factory StudentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StudentModel(
      id: doc.id,
      studentName: data['name'] ?? '',
      studentEmail: data['studentEmail'] ?? '',
      studentId: data['studentId'] ?? '',
      rollNumber: data['rollNumber'] ?? '',
      year: data['year'] ?? '',
      subject: data['subject'] ?? '',
      // Add null check for date field
      date: data['date'] != null ? (data['date'] as Timestamp).toDate() : null,
      dateString: data['dateString'] ?? '',
      present: data['present'] ?? false,
      status: data['status'] ?? 'Absent',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentName':studentName ,
      'studentEmail': studentEmail,
      'studentId': studentId,
      'rollNumber': rollNumber,
      'year': year,
      'subject': subject,
      // Only include date if it's not null
      if (date != null) 'date': Timestamp.fromDate(date!),
      'dateString': dateString,
      'present': present,
      'status': status,
    };
  }
}
