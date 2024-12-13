import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TODO App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> todos = [];

  void addTodo(String todo) {
    setState(() {
      todos.add(todo);
    });
  }

  void removeTodo(String todo) {
    setState(() {
      todos.remove(todo);
    });
  }

  void updateTodo(int index, String newTodo) {
    setState(() {
      todos[index] = newTodo;
    });
  }

  void createTodo() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TodoView(
          onSaveTodo: (todo) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("TODO Created Successfully"),
            ));
            addTodo(todo);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showTodo(String todo) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TodoView(
          todo: todo,
          onSaveTodo: (newTodo) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("TODO Updated Successfully"),
            ));
            updateTodo(todos.indexOf(todo), newTodo);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log("Rebuilding Stateful", name: "BUILD");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (todos.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.list_rounded, size: 48),
                    SizedBox(height: 8),
                    Text("No Todos"),
                    Text("Pleas add a todo")
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: todos.length,
              separatorBuilder: (context, index) {
                return const Divider(height: 0);
              },
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo),
                  onTap: () {
                    showTodo(todo);
                  },
                  trailing: IconButton(
                    onPressed: () {
                      removeTodo(todo);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createTodo();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TodoView extends StatefulWidget {
  final String? todo;
  final Function(String) onSaveTodo;
  const TodoView({super.key, this.todo, required this.onSaveTodo});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.text = widget.todo ?? '';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Rebuilding Stateful Form", name: "BUILD");

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Builder(
              builder: (context) {
                String title = "New Todo";
                if (widget.todo != null) {
                  title = "Update Todo";
                }
                return Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                );
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: TextFormField(
                controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Field is required";
                  }
                  return null;
                },
                maxLines: null,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onLongPress: () {
                setState(() {});
              },
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  widget.onSaveTodo(controller.text);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
