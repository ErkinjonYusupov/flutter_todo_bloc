import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_bloc/data/todo.dart';
import 'package:flutter_todo_bloc/todo_bloc/todo_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  addTodo(Todo todo) {
    context.read<TodoBloc>().add(AddTodo(todo));
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(RemoveTodo(todo));
  }

  alterTodo(int index) {
    context.read<TodoBloc>().add(AlterTodo(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController title = TextEditingController();
                TextEditingController text = TextEditingController();
                return AlertDialog(
                  title: const Text("Add a task"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: title,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: "Task title...",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: text,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: "Task text...",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          addTodo(Todo(title: title.text, subtitle: text.text));
                          title.text = '';
                          text.text = '';
                          Navigator.pop(context);
                        },
                        child: const Text("Qo'shish"))
                  ],
                );
              });
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text("My Todo App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
          if (state.status == TodoStatus.success) {
            return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, int i) {
                  return Card(
                    child: Slidable(
                        key: const ValueKey(0),
                        startActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          SlidableAction(
                              onPressed: (_) {
                                removeTodo(state.todos[i]);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: "Delete"),
                        ]),
                        child: ListTile(
                          title: Text(state.todos[i].title),
                          subtitle: Text(state.todos[i].subtitle),
                          trailing: Checkbox(
                            value: state.todos[i].isDone,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              alterTodo(i);
                            },
                          ),
                        )),
                  );
                });
          } else if (state.status == TodoStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
