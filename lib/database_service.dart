import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_with_firebase/todo_model.dart';

import 'deleted_todo_model.dart';
import 'note_model.dart';


class DatabaseService {
  final CollectionReference todoCollection =
      FirebaseFirestore.instance.collection('todos');

  final CollectionReference noteCollection =
  FirebaseFirestore.instance.collection('notes');

  User? user = FirebaseAuth.instance.currentUser;

  /////////////////////////////////////////Notes/////////////////////////////////

// Add note
  Future<DocumentReference> addNote(
      String title, String description) async {
    return await noteCollection.add({
      'uid': user!.uid,
      'title': title,
      'description': description,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update note
  Future<void> updateNote(String id, String title, String description) async {
    final updateNoteCollection =
    FirebaseFirestore.instance.collection('notes').doc(id);
    return await updateNoteCollection
        .update({'title': title, 'description': description,'createdAt': FieldValue.serverTimestamp(),});
  }

  //Update note status
  Future<void> updateNoteStatus(String id, bool completed) async {
    return await noteCollection.doc(id).update({'completed': completed});
  }

  //Delete note
  Future<void> deleteNote(String id) async {
    return await noteCollection.doc(id).delete();
  }
  //get pending notes
  Stream<List<Note>> get pendingNotes{
    return noteCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(noteListFromSnapshot);
  }

  //get completed notes
  Stream<List<Note>> get completedNotes {
    return noteCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(noteListFromSnapshot);
  }

  List<Note> noteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Note(
          id: doc.id,
          title: doc['title'] ?? '',
          description: doc['description'] ?? '',
          completed: doc['completed'] ?? false,
          timeStamp: doc['createdAt'] ?? '');
    }).toList();
  }



/////////////////////////////////////////////////Todos///////////////////////////////////////////////////////

  // Add todo task
  Future<DocumentReference> addTodoTask(
      String title, String description) async {
    return await todoCollection.add({
      'uid': user!.uid,
      'title': title,
      'description': description,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

// Update todo task
  Future<void> updateTodo(String id, String title, String description) async {
    final updateTodoCollection =
        FirebaseFirestore.instance.collection('todos').doc(id);
    return await updateTodoCollection
        .update({'title': title, 'description': description,'createdAt': FieldValue.serverTimestamp(),});
  }

//Update todo status
  Future<void> updateTodoStatus(String id, bool completed) async {
    return await todoCollection.doc(id).update({'completed': completed});
  }

//Delete todo
//   Future<void> deleteTodo(String id) async {
//     return await todoCollection.doc(id).delete();
//   }
  Future<void> deleteTodo(String id) async {
    if (user == null) {
      print('No user logged in');
      return;
    }

    final docRef = todoCollection.doc(id);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      print('Document with id $id does not exist');
      return;
    }

    final data = docSnapshot.data() as Map<String, dynamic>;

    try {
      // Step 1: Add to deleted_todos
      await FirebaseFirestore.instance.collection('deleted_todos').add({
        'uid': user!.uid,
        'title': data['title'],
        'description': data['description'],
        'completed': data['completed'],
        'deletedAt': FieldValue.serverTimestamp(),
      });

      // Step 2: Delete from original todos
      await docRef.delete();
      print('Todo deleted and moved to deleted_todos');
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

// Restore todo from deleted_todos to todos collection
  Future<void> restoreDeletedTodo(DeletedTodo todo) async {
    // Add back to todos
    await todoCollection.add({
      'uid': user!.uid,
      'title': todo.title,
      'description': todo.description,
      'completed': todo.completed,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Delete from deleted_todos
    await FirebaseFirestore.instance.collection('deleted_todos').doc(todo.id).delete();
  }

// Permanently delete todo from deleted_todos
  Future<void> permanentlyDeleteTodo(String id) async {
    await FirebaseFirestore.instance.collection('deleted_todos').doc(id).delete();
  }


//get pending todos
  Stream<List<Todo>> get pendingTodos {
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(todoListFromSnapshot);
  }

  //get completed todos
  Stream<List<Todo>> get completedTodos {
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(todoListFromSnapshot);
  }

  //get deleted todos
  Stream<List<DeletedTodo>> get deletedTodos {
    return FirebaseFirestore.instance
        .collection('deleted_todos')
        .where('uid', isEqualTo: user!.uid)
        .orderBy('deletedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => DeletedTodo.fromDoc(doc)).toList());
  }



  List<Todo> todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Todo(
          id: doc.id,
          title: doc['title'] ?? '',
          description: doc['description'] ?? '',
          completed: doc['completed'] ?? false,
          timeStamp: doc['createdAt'] ?? '');
    }).toList();
  }
}
