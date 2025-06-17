import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_with_firebase/database_service.dart';

import '../todo_model.dart';

class PendingTaskWidgets extends StatefulWidget {
  const PendingTaskWidgets({super.key});

  @override
  State<PendingTaskWidgets> createState() => _PendingTaskWidgetsState();
}

class _PendingTaskWidgetsState extends State<PendingTaskWidgets> {
  User? user=FirebaseAuth.instance.currentUser;
  late String uid;
  final DatabaseService databaseService=DatabaseService();

  @override
  void initState() {
    super.initState();
    uid=FirebaseAuth.instance.currentUser!.uid;
  }

  void showTaskDialog(BuildContext context, {Todo? todo}){
    TextEditingController titleController=TextEditingController(text: todo?.title);
    TextEditingController descriptionController=TextEditingController(text: todo?.description);

    DatabaseService databaseService=DatabaseService();
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(
          todo==null?'Add Task': 'Edit Task',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        content: SingleChildScrollView(
          child:SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      label: Text('Title'),
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      label: Text('Decription'),
                      border: OutlineInputBorder()
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, child: Text('Cancel'),
          ),
          ElevatedButton(
              onPressed: (){
                String title = titleController.text.trim();
                String description = descriptionController.text.trim();

                if (title.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title and description cannot be empty'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (todo == null) {
                  databaseService.addTodoTask(title, description);
                } else {
                  databaseService.updateTodo(todo.id, title, description);
                }
                Navigator.pop(context);

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: Text(todo==null?'Add':'Update')
          ),
        ],
      );
    },);

  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: databaseService.pendingTodos,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          List<Todo> todos=snapshot.data!;
          print('length:${snapshot.data!}');
          if (todos.isEmpty) {
            return const Center(child: Text("No pending tasks.",style: TextStyle(
              color: Colors.white
            ),));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todos.length,
              itemBuilder: (context, index) {
              Todo todo=todos[index];
              print('todo length:$todo');
              final DateTime dt=todo.timeStamp.toDate();
              return Container(
                margin: const EdgeInsets.all(10),
                //padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Slidable(
                  key: ValueKey(todo.id),
                  endActionPane: ActionPane(motion: const DrawerMotion(), children: [
                    SlidableAction(
                      onPressed: (context){
                      databaseService.updateTodoStatus(todo.id,true);
                    },
                    icon: Icons.done,
                      label: 'Mark',
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ]),
                  startActionPane: ActionPane(motion: const DrawerMotion(), children: [
                    SlidableAction(
                      onPressed: (context){
                        showTaskDialog(context,todo: todo);
                      },
                      icon: Icons.edit,
                      label: 'Edit',
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                      await  databaseService.deleteTodo(todo.id);
                      },
                      icon: Icons.delete,
                      label: 'Delete',
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ]),
                  child: ListTile(
                    title: Text(todo.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                    subtitle: Text(todo.description),
                    trailing: Text('${dt.day}/${dt.month}/${dt.year}'),
                  ),
                ),
              );
              },
          );
        }
        else{
          return const Center(child: CircularProgressIndicator(color: Colors.white,));
        }
    },
    );
  }
}
