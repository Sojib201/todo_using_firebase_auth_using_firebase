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

  final DatabaseService databaseService=DatabaseService();
  final TextEditingController _searchController = TextEditingController();

  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    databaseService.pendingNotes.listen((notes) {
      if (!mounted) return;
      setState(() {
        _allNotes = notes;
        _filteredNotes = notes;
        _isLoading = false;
      });
    });
  }

  void _onSearch(String value) {
    final query = value.toLowerCase().trim();
    setState(() {
      _filteredNotes = _allNotes.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.description.toLowerCase().contains(query);
      }).toList();
    });
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
      return formatTime(dt);
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: _onSearch,
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle:  TextStyle(color: Colors.white.withOpacity(0.3)),
                prefixIcon:  Icon(Icons.search, color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: const Color(0xFF101010),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : _filteredNotes.isEmpty
              ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: const Center(
              child: Text("No pending tasks.", style: TextStyle(color: Colors.white)),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredNotes.length,
            itemBuilder: (context, index) {
              Note note = _filteredNotes[index];
              final DateTime dt=note.timeStamp.toDate();
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotesDetailScreen(note: note),
                    ),
                  );
                },
                child: Container(
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
                    key: ValueKey(note.id),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            await databaseService.deleteNote(note.id);
                          },
                          icon: Icons.delete,
                          label: 'Delete',
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title.isNotEmpty ? note.title : note.description,
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.white.withOpacity(0.8)),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _getFormattedDateTime(dt),
                            style: TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // StreamBuilder<List<Note>>(
          //   stream: databaseService.pendingNotes,
          //   builder: (context, snapshot) {
          //     if(snapshot.hasData){
          //       List<Note> notes=snapshot.data!;
          //       print('length:${snapshot.data!}');
          //       if (notes.isEmpty) {
          //         return SizedBox(
          //           height: MediaQuery.of(context).size.height * 0.5,
          //           child: const Center(
          //             child: Text(
          //               "No pending tasks.",
          //               style: TextStyle(color: Colors.white),
          //             ),
          //           ),
          //         );
          //
          //       }
          //       return ListView.builder(
          //         padding: const EdgeInsets.symmetric(horizontal: 4),
          //         shrinkWrap: true,
          //         physics: const NeverScrollableScrollPhysics(),
          //         itemCount: notes.length,
          //         itemBuilder: (context, index) {
          //           Note note=notes[index];
          //           print('todo length:$note');
          //           final DateTime dt=note.timeStamp.toDate();
          //           return GestureDetector(
          //             onTap: (){
          //               print('xxxx');
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => NotesDetailScreen(note: note),
          //                 ),
          //               );
          //             },
          //             child: Container(
          //               margin: const EdgeInsets.all(6),
          //               padding: const EdgeInsets.symmetric(vertical: 8),
          //               decoration: BoxDecoration(
          //                 color: const Color(0xFF101010),
          //                 borderRadius: BorderRadius.circular(20),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.black.withOpacity(0.8),
          //                     offset: const Offset(6, 6),
          //                     blurRadius: 10,
          //                     spreadRadius: 1,
          //                   ),
          //                   BoxShadow(
          //                     color: Colors.black.withOpacity(0.6),
          //                     offset: const Offset(-6, -6),
          //                     blurRadius: 10,
          //                     spreadRadius: 1,
          //                   ),
          //                 ],
          //               ),
          //               child: Slidable(
          //                 key: ValueKey(note.id),
          //                 // startActionPane: ActionPane(motion: const DrawerMotion(), children: [
          //                 //   SlidableAction(
          //                 //     onPressed: (context){
          //                 //       showTaskDialog(context,note: note);
          //                 //     },
          //                 //     icon: Icons.edit,
          //                 //     label: 'Edit',
          //                 //     backgroundColor: Colors.amber,
          //                 //     foregroundColor: Colors.white,
          //                 //   ),
          //                 //
          //                 // ]),
          //                 endActionPane: ActionPane(motion: const DrawerMotion(), children: [
          //                   SlidableAction(
          //                     onPressed: (context) async {
          //                       await databaseService.deleteNote(note.id);
          //                     },
          //                     icon: Icons.delete,
          //                     label: 'Delete',
          //                     backgroundColor: Colors.red,
          //                     foregroundColor: Colors.white,
          //                   ),
          //                 ]),
          //                 child: ListTile(
          //                   contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          //                   title: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(note.title.isNotEmpty ? note.title : note.description,style:  TextStyle(fontSize: 19,color: Colors.white.withOpacity(0.8)),),
          //                       const SizedBox(height: 10,),
          //                       Text(
          //                         // '${dt.day}/${dt.month}/${dt.year}, ${formatTime(dt)}',
          //                         _getFormattedDateTime(dt),
          //                         style: TextStyle(color: Colors.white.withOpacity(0.5)),),
          //                     ],
          //                   ),
          //                   //subtitle: Text(maxLines:2,todo.description,style:  TextStyle(color: Colors.white.withOpacity(0.7),),),
          //                   // subtitle: Text(
          //                   //   // '${dt.day}/${dt.month}/${dt.year}, ${formatTime(dt)}',
          //                   //   _getFormattedDateTime(dt),
          //                   //   style: TextStyle(color: Colors.white.withOpacity(0.8)),),
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //       );
          //     }
          //     else{
          //       return const Center(child: CircularProgressIndicator(color: Colors.white,));
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
