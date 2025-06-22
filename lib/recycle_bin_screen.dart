import 'package:flutter/material.dart';
import 'package:to_do_with_firebase/database_service.dart';
import 'package:to_do_with_firebase/deleted_todo_model.dart';

class RecycleBinScreen extends StatefulWidget {
  const RecycleBinScreen({super.key});

  @override
  State<RecycleBinScreen> createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {
  final DatabaseService databaseService = DatabaseService();

  String formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
     // backgroundColor: const Color(0xFF121212),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Recycle Bin',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<DeletedTodo>>(
        stream: databaseService.deletedTodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong", style: TextStyle(color: Colors.white70)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SizedBox(
              height: size.height * 0.5,
              child: const Center(
                child: Text(
                  "Recycle Bin is empty.",
                  style: TextStyle(color: Colors.white54, fontSize: 18),
                ),
              ),
            );
          }

          final deletedTodos = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: deletedTodos.length,
            itemBuilder: (context, index) {
              final deletedTodo = deletedTodos[index];
              final DateTime dt = deletedTodo.timeStamp.toDate();

              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
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
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  title: Text(
                    deletedTodo.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        formatTime(dt),
                        style: TextStyle(color: Colors.white70.withOpacity(0.7), fontSize: 13),
                      ),
                    ],
                  ),
                  trailing: Wrap(
                    spacing: 12,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.restore, color: Colors.greenAccent),
                        onPressed: () async {
                          await databaseService.restoreDeletedTodo(deletedTodo);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
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
        },
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:to_do_with_firebase/database_service.dart';
// import 'package:to_do_with_firebase/deleted_todo_model.dart';
//
//
// class RecycleBinScreen extends StatefulWidget {
//   const RecycleBinScreen({super.key});
//
//   @override
//   State<RecycleBinScreen> createState() => _RecycleBinScreenState();
// }
//
// class _RecycleBinScreenState extends State<RecycleBinScreen> {
//
//   final DatabaseService databaseService=DatabaseService();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//   String formatTime(DateTime dt) {
//     final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
//     final minute = dt.minute.toString().padLeft(2, '0');
//     final amPm = dt.hour >= 12 ? 'PM' : 'AM';
//     return '$hour:$minute $amPm';
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           title: const Text('Recycle Bin',style: TextStyle(color: Colors.white),),
//       ),
//       body: StreamBuilder<List<DeletedTodo>>(
//         stream: databaseService.deletedTodos,
//         builder: (context, snapshot) {
//           if(snapshot.hasData){
//             List<DeletedTodo> deletedTodos=snapshot.data!;
//             print('length:${snapshot.data!}');
//             if (deletedTodos.isEmpty) {
//               return SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 child: const Center(
//                   child: Text(
//                     "Recycle Bin is empty.",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               );
//             }
//             return ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: deletedTodos.length,
//               itemBuilder: (context, index) {
//                 DeletedTodo deletedTodo=deletedTodos[index];
//                 print('todo length:$deletedTodo');
//                 final DateTime dt=deletedTodo.timeStamp.toDate();
//                 return Container(
//                   margin: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                       color: Colors.grey.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(10)
//                   ),
//                   child: ListTile(
//                     title: Text(
//                       deletedTodo.title,
//                       style: TextStyle(
//                         fontSize: 22,
//                         color: Colors.white.withOpacity(0.9),
//                       ),
//                     ),
//                   subtitle: Text(deletedTodo.description,style:  TextStyle(color: Colors.white.withOpacity(0.7)),),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.restore, color: Colors.green),
//                           onPressed: () async {
//                             await databaseService.restoreDeletedTodo(deletedTodo);
//                           },
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete_forever, color: Colors.red),
//                           onPressed: () async {
//                             await databaseService.permanentlyDeleteTodo(deletedTodo.id);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//
//               },
//             );
//           }
//           else{
//             return const Center(child: CircularProgressIndicator(color: Colors.white,));
//           }
//         },
//       ),
//     );
//   }
// }
//
