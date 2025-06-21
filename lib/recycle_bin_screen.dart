import 'package:flutter/material.dart';

import 'database_service.dart';
import 'deleted_todo_model.dart';

class RecycleBinScreen extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recycle Bin')),
      body: StreamBuilder<List<DeletedTodo>>(
        stream: databaseService.deletedTodos,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final deletedTodos = snapshot.data!;
          if (deletedTodos.isEmpty) {
            return Center(child: Text('Recycle Bin is empty.'));
          }

          return ListView.builder(
            itemCount: deletedTodos.length,
            itemBuilder: (context, index) {
              final todo = deletedTodos[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.restore, color: Colors.green),
                      onPressed: () async {
                        // Restore: add back to todos and delete from deleted_todos
                        await databaseService.restoreDeletedTodo(todo);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_forever, color: Colors.red),
                      onPressed: () async {
                        // Permanently delete
                        await databaseService.permanentlyDeleteTodo(todo.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
