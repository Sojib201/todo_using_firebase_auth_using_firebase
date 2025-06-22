// import 'package:flutter/material.dart';
//
// import 'database_service.dart';
// import 'deleted_todo_model.dart';
//
// class RecycleBinScreen extends StatelessWidget {
//   final DatabaseService databaseService = DatabaseService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text('Recycle Bin'),
//       ),
//       body: StreamBuilder<List<DeletedTodo>>(
//         stream: databaseService.deletedTodos,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child:Text('Recycle Bin is empty.'));
//
//           final deletedTodos = snapshot.data!;
//           if (deletedTodos.isEmpty) {
//             return const Center(child: Text('Recycle Bin is empty.'));
//           }
//
//           return ListView.builder(
//             itemCount: deletedTodos.length,
//             itemBuilder: (context, index) {
//               final todo = deletedTodos[index];
//               return ListTile(
//                 title: Text(todo.title),
//                 subtitle: Text(todo.description),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.restore, color: Colors.green),
//                       onPressed: () async {
//                         // Restore: add back to todos and delete from deleted_todos
//                         await databaseService.restoreDeletedTodo(todo);
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete_forever, color: Colors.red),
//                       onPressed: () async {
//                         // Permanently delete
//                         await databaseService.permanentlyDeleteTodo(todo.id);
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_with_firebase/database_service.dart';
import 'package:to_do_with_firebase/deleted_todo_model.dart';

import '../todo_model.dart';

class RecycleBinScreen extends StatefulWidget {
  const RecycleBinScreen({super.key});

  @override
  State<RecycleBinScreen> createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {

  final DatabaseService databaseService=DatabaseService();

  @override
  void initState() {
    super.initState();
  }
  String formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Recycle Bin',style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder<List<DeletedTodo>>(
        stream: databaseService.deletedTodos,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            List<DeletedTodo> deletedTodos=snapshot.data!;
            print('length:${snapshot.data!}');
            if (deletedTodos.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: const Center(
                  child: Text(
                    "Recycle Bin is empty.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: deletedTodos.length,
              itemBuilder: (context, index) {
                DeletedTodo deletedTodo=deletedTodos[index];
                print('todo length:$deletedTodo');
                final DateTime dt=deletedTodo.timeStamp.toDate();
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ListTile(
                    title: Text(
                      deletedTodo.title,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  subtitle: Text(deletedTodo.description,style:  TextStyle(color: Colors.white.withOpacity(0.7)),),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.restore, color: Colors.green),
                          onPressed: () async {
                            await databaseService.restoreDeletedTodo(deletedTodo);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: () async {
                            await databaseService.permanentlyDeleteTodo(deletedTodo.id);
                          },
                        ),
                      ],
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
      ),
    );
  }
}

