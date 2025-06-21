import 'package:cloud_firestore/cloud_firestore.dart';

class DeletedTodo {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final DateTime? deletedAt;

  DeletedTodo({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    this.deletedAt,
  });

  // ✅ This method fixes your error
  factory DeletedTodo.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeletedTodo(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      completed: data['completed'] ?? false,
      deletedAt: (data['deletedAt'] as Timestamp?)?.toDate(),
    );
  }
}
