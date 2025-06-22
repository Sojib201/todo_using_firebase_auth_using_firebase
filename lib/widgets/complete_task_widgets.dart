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
  String _getFormattedDateTime(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inHours < 24) {
      // Show time only
      return formatTime(dt);
    } else {
      // Show full date
      return '${dt.day}/${dt.month}/${dt.year}';
    }
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
            padding: const EdgeInsets.symmetric(horizontal: 4),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo=todos[index];
              print('todo length:$todo');
              final DateTime dt=todo.timeStamp.toDate();
              return Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF101010),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8),
                      offset: const Offset(6, 6),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: const Offset(-6, -6),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Slidable(
                  key: ValueKey(todo.id),
                  startActionPane: ActionPane(motion: const DrawerMotion(), children: [
                    SlidableAction(
                      onPressed: (context){
                        databaseService.updateTodoStatus(todo.id,false);
                      },
                      icon: Icons.done,
                      label: 'Mark as Incomplete',
                      backgroundColor: Colors.yellowAccent,
                      foregroundColor: Colors.black,
                    ),
                  ]),
                  endActionPane: ActionPane(motion: const DrawerMotion(), children: [
                    SlidableAction(
                      onPressed: (context) async {
                        await databaseService.deleteTodo(todo.id);
                      },
                      icon: Icons.delete,
                      label: 'Delete',
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ]),

                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todo.title,style:  TextStyle(fontSize: 19,color: Colors.white.withOpacity(0.8),decoration: TextDecoration.lineThrough),),
                        const SizedBox(height: 10,),
                        Text(
                          // '${dt.day}/${dt.month}/${dt.year}, ${formatTime(dt)}',
                          _getFormattedDateTime(dt),
                          style: TextStyle(color: Colors.white.withOpacity(0.5)),),
                      ],
                    ),
                    //subtitle: Text(maxLines:2,todo.description,style:  TextStyle(color: Colors.white.withOpacity(0.7),),),
                    // trailing: Text(
                    //   '${dt.day}/${dt.month}/${dt.year}, ${formatTime(dt)}',
                    //   //_getFormattedDateTime(dt),
                    //   style: TextStyle(color: Colors.white.withOpacity(0.8)),),
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
