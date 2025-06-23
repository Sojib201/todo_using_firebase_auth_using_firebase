import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_with_firebase/database_service.dart';
import 'package:to_do_with_firebase/note_model.dart';
import 'package:to_do_with_firebase/pending_note_widget.dart';

import 'notes_details_screen.dart';


class NotesTab extends StatefulWidget {
  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  final FirebaseAuth auth = FirebaseAuth.instance;

   void showTaskDialog(BuildContext context, {Note? note}){
     TextEditingController titleController=TextEditingController(text: note?.title);
     TextEditingController descriptionController=TextEditingController(text: note?.description);

     DatabaseService databaseService=DatabaseService();
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(
          note==null?'Add Notes': 'Edit Notes',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        content: SingleChildScrollView(
          child:SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                    border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    label: Text('Description'),
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
          }, child: const Text('Cancel'),
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

              if (note == null) {
                databaseService.addNote(title, description);
              } else {
                databaseService.updateNote(note.id, title, description);
              }
              Navigator.pop(context);

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            child: Text(note==null?'Add':'Update')
          ),
        ],
      );
    },);

   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const SingleChildScrollView(
        child: Column(
          children: [
            //SizedBox(height: 20,),
            PendingNoteWidgets()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor:Colors.grey.withOpacity(0.2),
        onPressed: (){
        //showTaskDialog(context );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotesDetailScreen(note: null),
            ),
          );
        },
        child: const Icon(Icons.add,color: Colors.blue,size: 36,),),
    );
  }
}
