import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:matchpoint/page/deleteAccount_page.dart';
import 'package:matchpoint/page/featureMatch_page.dart';
import 'package:matchpoint/page/historyMatch_page.dart';
import 'package:matchpoint/page/login_page.dart';
import 'package:matchpoint/page/settings_page.dart';
import 'firebase_options.dart';
import 'page/register_page.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/Home.dart';
import 'package:google_fonts/google_fonts.dart';

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
        routes: {
          '/register': (context) => RegisterPage(),
          '/home': (context) => const MyHomePage(),
          '/login': (context) => const LoginPage(),
          '/feature': (context) => const FeatureMatchPage(),
          '/history': (context) => const HistoryMatchPage(),
          '/settings': (context) => const SettingsPage(),
          '/deleteAcc': (context) => const DeleteAccountPage(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: GoogleFonts.quicksandTextTheme(),
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return MyHomePage(); // Sudah login
        } else {
          return LoginPage(); // Belum login
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State Class
class _MyHomePageState extends State<MyHomePage> {
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "btn1", // Tambahkan heroTag untuk menghindari error
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RegisterPage()), // Ganti dengan nama halaman register
              );
            },
            tooltip: "Go to Register Page",
            child: Icon(Icons.person_add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "btn2", // Tambahkan heroTag untuk menghindari error
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FeatureMatchPage()), // Ganti dengan nama halaman register
              );
            },
            tooltip: "Go to feature Page",
            child: Icon(Icons.person_outline),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "btn3",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryMatchPage()),
              );
            },
            tooltip: "Go to feature Page",
            child: Icon(Icons.history),
          ),
          SizedBox(height: 16), // Jarak antar tombol
          FloatingActionButton(
            heroTag: "btn4",
            onPressed: () {
              _showAddNotionItemDialog(context);
            },
            tooltip: "Add Match",
            child: Icon(Icons.add),
          ),
        ],
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
