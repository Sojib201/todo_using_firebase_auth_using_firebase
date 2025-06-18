import 'package:flutter/material.dart';
import '../todo_model.dart';
import '../database_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Todo todo;

  const TaskDetailScreen({super.key, required this.todo});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    descriptionController = TextEditingController(text: widget.todo.description);
  }
  @override
  void dispose(){
    String title = titleController.text.trim();
    String desc = descriptionController.text.trim();

    if (title != widget.todo.title || desc != widget.todo.description)
    {
      _databaseService.updateTodo(widget.todo.id, title, desc);

    }
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }


  String formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }

  void _updateTask() async {
    String title = titleController.text.trim();
    String desc = descriptionController.text.trim();

    if (title != widget.todo.title || desc != widget.todo.description)
    {
      _databaseService.updateTodo(widget.todo.id, title, desc);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task updated"),
          backgroundColor: Colors.green,
        ),
      );
    }


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Task updated"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dt = widget.todo.timeStamp.toDate();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Todo Details',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${dt.day}/${dt.month}/${dt.year}, ${formatTime(dt)}',
                style:  TextStyle(color: Colors.white.withOpacity(0.6)),),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: null,
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
                ),
      ),
    );
  }
}
