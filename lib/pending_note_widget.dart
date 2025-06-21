import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_with_firebase/database_service.dart';

import 'note_model.dart';
import 'notes_details_screen.dart';

class PendingNoteWidgets extends StatefulWidget {
  const PendingNoteWidgets({super.key});

  @override
  State<PendingNoteWidgets> createState() => _PendingNoteWidgetsState();
}

class _PendingNoteWidgetsState extends State<PendingNoteWidgets> {
  late String uid;
  final DatabaseService databaseService=DatabaseService();

  @override
  void initState() {
    super.initState();
    uid=FirebaseAuth.instance.currentUser!.uid;
  }

  void showTaskDialog(BuildContext context, {Note? note}){
    TextEditingController titleController=TextEditingController(text: note?.title);
    TextEditingController descriptionController=TextEditingController(text: note?.description);

    DatabaseService databaseService=DatabaseService();
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(
          note==null?'Add Task': 'Edit Task',
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
    return StreamBuilder<List<Note>>(
      stream: databaseService.pendingNotes,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          List<Note> notes=snapshot.data!;
          print('length:${snapshot.data!}');
          if (notes.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: const Center(
                child: Text(
                  "No pending tasks.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );

          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              Note note=notes[index];
              print('todo length:$note');
              final DateTime dt=note.timeStamp.toDate();
              return GestureDetector(
                onTap: (){
                  print('xxxx');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotesDetailScreen(note: note),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white12.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Slidable(
                    key: ValueKey(note.id),
                    endActionPane: ActionPane(motion: const DrawerMotion(), children: [
                      SlidableAction(
                        onPressed: (context){
                          databaseService.updateNoteStatus(note.id,true);
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
                          showTaskDialog(context,note: note);
                        },
                        icon: Icons.edit,
                        label: 'Edit',
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await databaseService.deleteNote(note.id);
                        },
                        icon: Icons.delete,
                        label: 'Delete',
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ]),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(note.title,style:  TextStyle(fontSize: 19,color: Colors.white.withOpacity(0.8)),),
                          const SizedBox(height: 10,),
                          Text(
                            // '${dt.day}/${dt.month}/${dt.year}, ${formatTime(dt)}',
                            _getFormattedDateTime(dt),
                            style: TextStyle(color: Colors.white.withOpacity(0.5)),),
                        ],
                      ),
                      //subtitle: Text(maxLines:2,todo.description,style:  TextStyle(color: Colors.white.withOpacity(0.7),),),
                      // subtitle: Text(
                      //   // '${dt.day}/${dt.month}/${dt.year}, ${formatTime(dt)}',
                      //   _getFormattedDateTime(dt),
                      //   style: TextStyle(color: Colors.white.withOpacity(0.8)),),
                    ),
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
