import 'package:flutter/material.dart';
import 'package:matchpoint/model/firebase_service.dart';
import 'package:matchpoint/page/deleteAccount_page.dart';
import 'package:matchpoint/page/forgotPassword_page.dart';
import 'package:matchpoint/page/login_page.dart';
import 'package:matchpoint/widgets/editUsernameDialog_widget.dart';
import 'package:matchpoint/widgets/loginRegisterField_widget.dart';
import 'package:matchpoint/widgets/logoutDialog_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matchpoint/widgets/toast_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isAccountExpanded = false;
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseService _auth = FirebaseService();

  String _username = 'Loading...';
  String _dateCreated = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      final userData = await _auth.getUserData(user!.uid);
      if (userData != null && mounted) {
        setState(() {
          _username = userData.username ?? "Unknown";
          _dateCreated = userData.dateCreated ?? "Unknown";
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.black12,
            height: 1,
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
                subtitle: Text(_username),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    editUsernameDialog(
                      context: context,
                      currentUsername: _username,
                      onSave: (newName) {
                        setState(() {
                          _username = newName;
                        });
                      },
                    );
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                subtitle: Text(user?.email ?? 'johndoe@gmail.com'),
              ),
              ListTile(
                leading: const Icon(Icons.key),
                title: const Text("Reset Password"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPassword()),
                  );
                },
              ),
              // CheckboxListTile(
              //   secondary: const Icon(Icons.login),
              //   title: const Text("Sign in with Google"),
              //   value: true,
              //   onChanged: null, // disabled, hanya indikator
              // ),
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
            title: const Text("Account Created"),
            trailing: Text(
              _dateCreated,
              style: TextStyle(color: Colors.grey),
            ),
            // onTap: () {
            // Sinkronisasi
            // },
          ),
          const Divider(height: 1, color: Colors.black12),
          ListTile(
            title: const Text("Language"),
            trailing: const Text(
              "English",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              // something
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 0.3,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            onPressed: () => {showLogOutDialog(context)},
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              splashFactory: NoSplash.splashFactory,
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
