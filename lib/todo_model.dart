import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Todo{
  final String id;
  final String title;
  final String description;
  final bool completed;
  final Timestamp timeStamp;

  Todo(
  {
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.timeStamp,
});

}




// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Todo {
//   final String id;
//   final String title;
//   final String description;
//   final bool completed;
//   final Timestamp timeStamp;
//
//
//   Todo({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.completed,
//     required this.timeStamp,
//
//   });
//
//   // Factory constructor to create a Todo from Firestore document snapshot
//   factory Todo.fromDocumentSnapshot(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Todo(
//       id: doc.id,
//       title: data['title'] ?? '',
//       description: data['description'] ?? '',
//       completed: data['completed'] ?? false,
//       timeStamp: data['createdAt'] ?? Timestamp.now(),
//     );
//   }
//
//   // Convert Todo to JSON (for uploading to Firestore)
//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'description': description,
//       'completed': completed,
//       'createdAt': timeStamp,
//
//     };
//   }
// }
