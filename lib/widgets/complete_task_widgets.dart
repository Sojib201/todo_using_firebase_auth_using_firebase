import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_with_firebase/database_service.dart';

import '../todo_model.dart';

class CompleteTaskWidgets extends StatefulWidget {
  const CompleteTaskWidgets({super.key});

  @override
  State<CompleteTaskWidgets> createState() => _CompleteTaskWidgetsState();
}

class _CompleteTaskWidgetsState extends State<CompleteTaskWidgets> {
  User? user=FirebaseAuth.instance.currentUser;
  late String uid;
  final DatabaseService databaseService=DatabaseService();

  @override
  void initState() {
    super.initState();
    uid=FirebaseAuth.instance.currentUser!.uid;
  }
  String formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: databaseService.completedTodos,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          List<Todo> todos=snapshot.data!;
          print('length:${snapshot.data!}');
          if (todos.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: const Center(
                child: Text(
                  "No Completed tasks.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
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
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Slidable(
                  key: ValueKey(todo.id),
                  endActionPane: ActionPane(motion: const DrawerMotion(), children: [
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
                    title: Text(todo.title,style:  TextStyle(fontSize: 22,color: Colors.white.withOpacity(0.9),decoration: TextDecoration.lineThrough),),
                    subtitle: Text(todo.description,style:  TextStyle(color: Colors.white.withOpacity(0.7),decoration: TextDecoration.lineThrough),),
                    trailing: Text(
                      '${dt.day}/${dt.month}/${dt.year}, ${formatTime(dt)}',
                      style:  TextStyle(color: Colors.white.withOpacity(0.9)),),
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
