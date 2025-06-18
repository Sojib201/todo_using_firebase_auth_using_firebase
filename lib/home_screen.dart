// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:to_do_with_firebase/auth_service.dart';
// import 'package:to_do_with_firebase/database_service.dart';
// import 'package:to_do_with_firebase/login_screen.dart';
// import 'package:to_do_with_firebase/todo_model.dart';
// import 'package:to_do_with_firebase/widgets/complete_task_widgets.dart';
// import 'package:to_do_with_firebase/widgets/pending_task_widgets.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   int buttonIndex=0;
//    final widgets=[
//      //Pending todos
//      const PendingTaskWidgets(),
//      //Completed todos
//      const CompleteTaskWidgets()
//    ];
//
//    void showTaskDialog(BuildContext context, {Todo? todo}){
//      TextEditingController titleController=TextEditingController(text: todo?.title);
//      TextEditingController descriptionController=TextEditingController(text: todo?.description);
//
//      DatabaseService databaseService=DatabaseService();
//     showDialog(context: context, builder: (context) {
//       return AlertDialog(
//         title: Text(
//             todo==null?'Add Task': 'Edit Task',
//           style: TextStyle(fontWeight: FontWeight.w500),
//         ),
//         content: SingleChildScrollView(
//           child:SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: Column(
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: InputDecoration(
//                     label: Text('Title'),
//                     border: OutlineInputBorder()
//                   ),
//                 ),
//                 SizedBox(height: 10,),
//                 TextField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(
//                     label: Text('Decription'),
//                     border: OutlineInputBorder()
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: (){
//             Navigator.pop(context);
//           }, child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: (){
//               String title = titleController.text.trim();
//               String description = descriptionController.text.trim();
//
//               if (title.isEmpty || description.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Title and description cannot be empty'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//                 return;
//               }
//
//               if (todo == null) {
//                 databaseService.addTodoTask(title, description);
//               } else {
//                 databaseService.updateTodo(todo.id, title, description);
//               }
//               Navigator.pop(context);
//
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.indigo,
//               foregroundColor: Colors.white,
//             ),
//             child: Text(todo==null?'Add':'Update')
//           ),
//         ],
//       );
//     },);
//
//    }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//
//         backgroundColor: Colors.black,
//         title:  const Text('Todo List',style: TextStyle(
//           color: Colors.white,
//           fontSize: 22
//         ),),
//         //centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await AuthService().signOut();
//               Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
//             },
//             icon: Icon(Icons.logout,color: Colors.white,),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 20,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 InkWell(
//                   borderRadius: BorderRadius.circular(10),
//                   onTap: (){
//                     setState(() {
//                       buttonIndex=0;
//                     });
//                   },
//                   child: Container(
//                     height: 50,
//                       width: MediaQuery.of(context).size.width/2.2,
//                       decoration: BoxDecoration(
//                         color: buttonIndex==0?Colors.indigo:Colors.white,
//                         borderRadius: BorderRadius.circular(10)
//                       ),
//                       child:  Center(
//                         child: Text('Pending',style: TextStyle(
//                          fontWeight: FontWeight.w500,
//                           fontSize: 20,
//                           color: buttonIndex==0?Colors.white:Colors.black
//                         ),),
//                       )),
//                 ),
//                 InkWell(
//                     borderRadius: BorderRadius.circular(10),
//                   onTap: (){
//                     setState(() {
//                       buttonIndex=1;
//                     });
//                   },
//                   child: Container(
//                       height: 50,
//                       width: MediaQuery.of(context).size.width/2.2,
//                       decoration: BoxDecoration(
//                           color: buttonIndex==1?Colors.indigo:Colors.white,
//                           borderRadius: BorderRadius.circular(10)
//                       ),
//                       child:  Center(
//                         child: Text('Completed',style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 20,
//                             color:  buttonIndex==1?Colors.white:Colors.black
//                         ),),
//                       )),
//                 )
//               ],
//             ),
//             const SizedBox(height: 10,),
//             widgets[buttonIndex],
//
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         shape: const CircleBorder(),
//         backgroundColor:Colors.grey.withOpacity(0.2),
//         onPressed: (){
//         showTaskDialog(context );
//         },
//         child: const Icon(Icons.add,color: Colors.blue,),),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:to_do_with_firebase/todo_tab.dart';

import 'notes_tab.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    NotesTab(),
    TodoTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Todo',
          ),
        ],
      ),
    );
  }
}

