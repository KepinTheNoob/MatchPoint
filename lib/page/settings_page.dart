import 'package:flutter/material.dart';
import 'package:matchpoint/page/deleteAccount_page.dart';
import 'package:matchpoint/page/login_page.dart';
import 'package:matchpoint/widgets/logOut_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isAccountExpanded = false;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: const Color(0xFFF3FEFD),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.black12, // Warna border
            height: 1, // Ketebalan border
          ),
        ),
      ),
      body: Column(
        children: [
          ExpansionTile(
            initiallyExpanded: _isAccountExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _isAccountExpanded = expanded;
              });
            },
            title: const Text("Account"),
            trailing: Icon(
              _isAccountExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.black54,
            ),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Username"),
                subtitle: Text(user?.displayName ?? 'John Doe'),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                subtitle: Text(user?.email ?? 'johndoe@gmail.com'),
              ),
              ListTile(
                leading: const Icon(Icons.key),
                title: const Text("Change Password"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                // subtitle: const Text("johndoe@example.com"),
              ),
              CheckboxListTile(
                secondary: const Icon(Icons.login),
                title: const Text("Sign in with Google"),
                value: true,
                onChanged: null, // disabled, hanya indikator
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  "Delete Account",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DeleteAccountPage()),
                  );
                },
              ),
            ],
          ),
          const Divider(height: 1, color: Colors.black12),
          ListTile(
            title: const Text("Sync Data"),
            trailing: const Text(
              "Last Sync: 28 Aug 2021",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              // Sinkronisasi
            },
          ),
          const Divider(height: 1, color: Colors.black12),
          ListTile(
            title: const Text("Language"),
            trailing: const Text(
              "English",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              // TODO: Ubah bahasa
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black, // Warna border top
              width: 0.3, // Ketebalan border
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
            20, 0, 20, 20), // padding agar tidak mentok ke pinggir dan bawah
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            onPressed: () => {showLogOutDialog(context)},
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              splashFactory: NoSplash.splashFactory, // tanpa splash
            ),
            child: const Text(
              'Log out',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
