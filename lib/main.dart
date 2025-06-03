import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:matchpoint/page/HistoryMatch/createHistory_page.dart';
import 'package:matchpoint/page/RealTimeMatch/createRealScoring_page.dart';
import 'package:matchpoint/page/deleteAccount_page.dart';
import 'package:matchpoint/page/featureMatch_page.dart';
import 'package:matchpoint/page/home_page.dart';
import 'package:matchpoint/page/login_page.dart';
import 'package:matchpoint/page/settings_page.dart';
import 'firebase_options.dart';
import 'page/register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Set System UI Overlay Style (Android)
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemStatusBarContrastEnforced: true,
    systemNavigationBarColor: Colors.lightBlueAccent[100],
    systemNavigationBarDividerColor: Colors.lightBlue[700],
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Set System UI Mode for Edge-to-Edge (Full Screen)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);

  // Biar bisa dijalanin
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MatchPoint Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: {
        '/register': (context) => RegisterPage(),
        '/home': (context) => const Home(),
        '/login': (context) => const LoginPage(),
        '/feature': (context) => FeatureMatchPage(),
        '/settings': (context) => const SettingsPage(),
        '/deleteAcc': (context) => const DeleteAccountPage(),
        '/createHist': (context) => const CreateHistory(),
        '/createRealScoring': (context) => const LiveScoringPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.quicksandTextTheme(),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: CircleBorder(),
        ),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: AuthWrapper(),
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
          return Home(); // Sudah login
        } else {
          return LoginPage(); // Belum login
        }
      },
    );
  }
}
