import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_with_firebase/auth_service.dart';
import 'package:to_do_with_firebase/database_service.dart';
import 'package:to_do_with_firebase/login_screen.dart';
import 'package:to_do_with_firebase/recycle_bin_screen.dart';
import 'package:to_do_with_firebase/todo_model.dart';
import 'package:to_do_with_firebase/widgets/complete_task_widgets.dart';
import 'package:to_do_with_firebase/widgets/pending_task_widgets.dart';

class TodoTab extends StatefulWidget {
  @override
  State<TodoTab> createState() => _TodoTabState();
}

class _TodoTabState extends State<TodoTab> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  int buttonIndex = 0;
  final widgets = [
    const PendingTaskWidgets(),
    const CompleteTaskWidgets(),
  ];

  void showTaskDialog(BuildContext context, {Todo? todo}) {
    TextEditingController titleController = TextEditingController(text: todo?.title);
    TextEditingController descriptionController = TextEditingController(text: todo?.description);

    DatabaseService databaseService = DatabaseService();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            todo == null ? 'Add Task' : 'Edit Task',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      label: Text('Description'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
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
              child: Text(todo == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.9,
                height: 50,
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
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 10),
                      curve: Curves.easeInOut,
                      left: buttonIndex == 0 ? 0 : screenWidth * 0.45,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: screenWidth * 0.45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          //color: const Color(0xFF5A6AFF),
                          color:  Colors.green,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              setState(() {
                                buttonIndex = 0;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: Text(
                                'Pending',
                                style: TextStyle(
                                  color: buttonIndex == 0 ? Colors.white : Colors.white54,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              setState(() {
                                buttonIndex = 1;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  color: buttonIndex == 1 ? Colors.white : Colors.white54,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: widgets[buttonIndex],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'addTaskBtn',
            shape: const CircleBorder(),
            backgroundColor: const Color(0xFF1E1E1E),
            onPressed: () {
              showTaskDialog(context);
            },
            elevation: 8,
            child: const Icon(Icons.add, color: Colors.indigo, size: 36),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            backgroundColor: const Color(0xFF1E1E1E),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecycleBinScreen()),
              );
            },
            child:  const Center(
              child: Icon(
                Icons.auto_delete_sharp,
                color: Colors.redAccent,
                size: 22,
              ),
            ),
          ),
        ],
      ),

    );
  }
}




// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:to_do_with_firebase/auth_service.dart';
// import 'package:to_do_with_firebase/database_service.dart';
// import 'package:to_do_with_firebase/login_screen.dart';
// import 'package:to_do_with_firebase/recycle_bin_screen.dart';
// import 'package:to_do_with_firebase/todo_model.dart';
// import 'package:to_do_with_firebase/widgets/complete_task_widgets.dart';
// import 'package:to_do_with_firebase/widgets/pending_task_widgets.dart';
//
// class TodoTab extends StatefulWidget {
//   @override
//   State<TodoTab> createState() => _TodoTabState();
// }
//
// class _TodoTabState extends State<TodoTab> {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   int buttonIndex=0;
//   final widgets=[
//     //Pending todos
//     const PendingTaskWidgets(),
//     //Completed todos
//     const CompleteTaskWidgets()
//   ];
//
//   void showTaskDialog(BuildContext context, {Todo? todo}){
//     TextEditingController titleController=TextEditingController(text: todo?.title);
//     TextEditingController descriptionController=TextEditingController(text: todo?.description);
//
//     DatabaseService databaseService=DatabaseService();
//     showDialog(context: context, builder: (context) {
//       return AlertDialog(
//         title: Text(
//           todo==null?'Add Task': 'Edit Task',
//           style: const TextStyle(fontWeight: FontWeight.w500),
//         ),
//         content: SingleChildScrollView(
//           child:SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: Column(
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(
//                       label: Text('Title'),
//                       border: OutlineInputBorder()
//                   ),
//                 ),
//                 const SizedBox(height: 10,),
//                 TextField(
//                   controller: descriptionController,
//                   decoration: const InputDecoration(
//                       label: Text('Decription'),
//                       border: OutlineInputBorder()
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: (){
//               Navigator.pop(context);
//             }, child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//               onPressed: (){
//                 String title = titleController.text.trim();
//                 String description = descriptionController.text.trim();
//
//                 if (title.isEmpty || description.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Title and description cannot be empty'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                   return;
//                 }
//
//                 if (todo == null) {
//                   databaseService.addTodoTask(title, description);
//                 } else {
//                   databaseService.updateTodo(todo.id, title, description);
//                 }
//                 Navigator.pop(context);
//
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.indigo,
//                 foregroundColor: Colors.white,
//               ),
//               child: Text(todo==null?'Add':'Update')
//           ),
//         ],
//       );
//     },);
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           const SizedBox(height: 20,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               InkWell(
//                 borderRadius: BorderRadius.circular(10),
//                 onTap: (){
//                   setState(() {
//                     buttonIndex=0;
//                   });
//                 },
//                 child: Container(
//                     height: 50,
//                     width: MediaQuery.of(context).size.width/2.2,
//                     decoration: BoxDecoration(
//                         color: buttonIndex==0?Colors.indigo:Colors.white,
//                         borderRadius: BorderRadius.circular(10)
//                     ),
//                     child:  Center(
//                       child: Text('Pending',style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 20,
//                           color: buttonIndex==0?Colors.white:Colors.black
//                       ),),
//                     )),
//               ),
//               InkWell(
//                 borderRadius: BorderRadius.circular(10),
//                 onTap: (){
//                   setState(() {
//                     buttonIndex=1;
//                   });
//                 },
//                 child: Container(
//                     height: 50,
//                     width: MediaQuery.of(context).size.width/2.2,
//                     decoration: BoxDecoration(
//                         color: buttonIndex==1?Colors.indigo:Colors.white,
//                         borderRadius: BorderRadius.circular(10)
//                     ),
//                     child:  Center(
//                       child: Text('Completed',style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 20,
//                           color:  buttonIndex==1?Colors.white:Colors.black
//                       ),),
//                     )),
//               )
//             ],
//           ),
//           const SizedBox(height: 10,),
//           Expanded(
//             child: SingleChildScrollView(
//                   child: widgets[buttonIndex]
//               ),
//           ),
//         ],
//       ),
//       floatingActionButton: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//
//
//           FloatingActionButton.large(
//             heroTag: 'recycleBinBtn',
//             shape: const CircleBorder(),
//             backgroundColor: Colors.grey.withOpacity(0.2),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const RecycleBinScreen()),
//               );
//             },
//             tooltip: 'Recently Deleted',
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.white
//               ),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.auto_delete_sharp, color: Colors.red, size: 20,),
//                   Text('Recently Deleted',maxLines:2,style: TextStyle(color: Colors.white,fontSize: 6),),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           FloatingActionButton(
//             heroTag: 'addTaskBtn',
//             shape: const CircleBorder(),
//             backgroundColor: Colors.grey.withOpacity(0.2),
//             onPressed: () {
//               showTaskDialog(context);
//             },
//             child: const Icon(Icons.add, color: Colors.blue, size: 36),
//           ),
//         ],
//       ),
//
//     );
//   }
// }
