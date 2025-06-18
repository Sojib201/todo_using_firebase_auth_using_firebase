import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_with_firebase/auth_service.dart';
import 'package:to_do_with_firebase/database_service.dart';
import 'package:to_do_with_firebase/login_screen.dart';
import 'package:to_do_with_firebase/pending_note_widget.dart';
import 'package:to_do_with_firebase/todo_model.dart';
import 'package:to_do_with_firebase/widgets/complete_task_widgets.dart';
import 'package:to_do_with_firebase/widgets/pending_task_widgets.dart';

class NotesTab extends StatefulWidget {
  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  int buttonIndex=0;
   final widgets=[
     //Pending todos
     const PendingNoteWidgets(),
   ];

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
                databaseService.addNote(title, description);
              } else {
                databaseService.updateNote(todo.id, title, description);
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        backgroundColor: Colors.black,
        title:  const Text('Notes',style: TextStyle(
          color: Colors.white,
          fontSize: 22
        ),),
        //centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
            },
            icon: Icon(Icons.logout,color: Colors.white,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            PendingTaskWidgets()

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor:Colors.grey.withOpacity(0.2),
        onPressed: (){
        showTaskDialog(context );
        },
        child: const Icon(Icons.add,color: Colors.blue,),),
    );
  }
}
