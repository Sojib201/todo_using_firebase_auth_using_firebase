import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_with_firebase/todo_model.dart';

class DatabaseService{
  final CollectionReference todoCollection= FirebaseFirestore.instance.collection('todos');
  User? user=FirebaseAuth.instance.currentUser;

  // Add todo task
Future<DocumentReference> addTodoTask(String title, String description) async {
  return await todoCollection.add({
    'uid':user!.uid,
    'title':title,
    'description':description,
    'completed':false,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

// Update todo task
Future<void> updateTodo(String id, String title, String description) async {
  final updateTodoCollection= FirebaseFirestore.instance.collection('todos').doc(id);
  return await updateTodoCollection.update({
    'title':title,
    'description':description
  });
}

//Update todo status
Future<void> updateTodoStatus(String id, bool completed) async {
  return await todoCollection.doc(id).update({
    'completed': completed
  });
}

//Delete todo
Future<void> deleteTodo(String id) async{
  return await todoCollection.doc(id).delete();
}


//get pending todos
  Stream<List<Todo>> get pendingTodos{
  return todoCollection.where('uid', isEqualTo: user!.uid).where('completed', isEqualTo: false).snapshots().map(todoListFromSnapshot);
  }

  //get completed todos
  Stream<List<Todo>> get completedTodos{
    return todoCollection.where('uid', isEqualTo: user!.uid).where('completed', isEqualTo: true).snapshots().map(todoListFromSnapshot);
  }


List<Todo> todoListFromSnapshot(QuerySnapshot snapshot){
  return snapshot.docs.map((doc){
    return Todo(
      id:doc.id,
      title:doc['title'] ?? '',
      description:doc['description']??'',
      completed:doc['completed']??false,
      timeStamp: doc['createdAt']??''
    );
  }).toList();
}


}