import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Biar bisa dijalanin
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Home(),
      child: MaterialApp(
        title: 'MatchPoint Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // const MyHomePage({super.key, required this.title});
  const MyHomePage({super.key});
  // final String title; // App state

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State Class
class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0; // Kalo variabel ada didalam stateclass -> ephemeral state

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MatchPoint Demo")),
      body: Consumer<Home>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.notionItem.length,
            itemBuilder: (context, index) {
              final item = value.notionItem[index];
              return ListTile(
                title: Text(item.title),
                subtitle: Text(item.description),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    value.deleteItem(item.id);
                  },
                ),
                onTap: () {
                  _showEditNotionItemDialog(context, item);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNotionItemDialog(context);
        },
        tooltip: "Add Match",
        child: Icon(Icons.add),
      ),
    );
  }
}

void _showAddNotionItemDialog(BuildContext context) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isChecked = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("MatchPoint"),
            content: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Input Match Title",
                  ),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "Input Match Description",
                  ),
                ),
                CheckboxListTile(
                  title: Text("isFinish?"),
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final home = Provider.of<Home>(
                    context,
                    listen: false,
                  );
                  home.addItem(
                    titleController.text,
                    descController.text,
                    isChecked,
                  );
                  Navigator.of(context).pop();
                },
                child: Text("Add"),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showEditNotionItemDialog(BuildContext context, NotionItem item) {
  TextEditingController titleController = TextEditingController(
    text: item.title,
  );
  TextEditingController descController = TextEditingController(
    text: item.description,
  );
  bool isChecked = item.isChecked;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Edit MatchPoint"),
            content: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Input Match Title",
                  ),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "Input Match Description",
                  ),
                ),
                CheckboxListTile(
                  title: Text("isFinish?"),
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                      item.isChecked = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final home = Provider.of<Home>(
                    context,
                    listen: false,
                  );
                  home.updateItem(
                    item.id,
                    titleController.text,
                    descController.text,
                    isChecked,
                  );
                  Navigator.of(context).pop();
                },
                child: Text("Save"),
              ),
            ],
          );
        },
      );
    },
  );
}
