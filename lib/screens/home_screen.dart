import 'package:flutter/material.dart';
import '../database/todo_database.dart';
import '../models/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final todoList = await TodoDatabase.instance.fetchTodos();
    setState(() {
      todos = todoList.map((e) => Todo.fromMap(e)).toList();
    });
  }

  void addTodo() async {
    final newTodo = Todo(
      title: 'New Task',
      description: 'Description',
      isDone: false,
    );
    await TodoDatabase.instance.insertTodo(newTodo.toMap());
    loadTodos();
  }

  void updateTodoStatus(Todo todo) async {
    await TodoDatabase.instance.updateTodo(
      todo.id!,
      todo.toMap(),
    );
    loadTodos();
  }

  void deleteTodo(int id) async {
    await TodoDatabase.instance.deleteTodo(id);
    loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addTodo,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.description),
            trailing: Checkbox(
              value: todo.isDone,
              // onChanged: (value) {
              //   updateTodoStatus(todo.copyWith(isDone: value!));
              // },
              onChanged: (value) {
                final updatedTodo = Todo(
                  id: todo.id,
                  title: todo.title,
                  description: todo.description,
                  isDone: value!,
                );
                updateTodoStatus(updatedTodo);
              },

            ),
            onLongPress: () => deleteTodo(todo.id!),
          );
        },
      ),
    );
  }
}
