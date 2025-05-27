import 'package:flutter/material.dart';
import 'package:matchpoint/page/login_page.dart';
import 'package:matchpoint/page/register_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isAccountExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF0F8FFFE),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: const Color(0xF0F8FFFE),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const Divider(height: 1, color: Colors.black12),
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
                subtitle: const Text("JohnDoe"),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                subtitle: const Text("johndoe@example.com"),
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
                        builder: (context) => const RegisterPage()),
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
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text(
                "Log out",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
