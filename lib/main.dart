import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/bottombar_nav.dart';
import 'providers/book_provider.dart';
import 'providers/user_provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../models/authgate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is properly initialized before Firebase

  try {
    // Initialize Firebase for the correct platform (web or Android)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ); // Connects the app to the firebase project
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
    } else {
      rethrow;
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Global providers for user, book data, and navigation state
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => NavigationBottomBar()),
      ],
      child: MaterialApp(
        title: 'Paige',
        debugShowCheckedModeBanner: false,
        // The app’s color theme (FlexColorScheme)
        theme: FlexThemeData.light(
          colors: const FlexSchemeColor(
            primary: Color(0xff2e7d32),
            primaryContainer: Color(0xffa5d6a7),
            secondary: Color(0xff00695c),
            secondaryContainer: Color(0xff7dcec4),
            tertiary: Color(0xff004d40),
            tertiaryContainer: Color(0xff59b1a1),
            appBarColor: Color(0xff7dcec4),
            error: Color(0xffb00020),
          ),
        ),
        // Directs the user to AuthGate, which decides whether to show
        // the login screen or the active RootPage
        home: const AuthGate(),
      ),
    );
  }
}
