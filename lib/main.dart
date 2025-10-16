import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';
import 'model.dart';
import 'api_getbooks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // --- Minimal test av Firebase Realtime Database ---
  try {
    final ref = FirebaseDatabase.instance.ref("testConnection");
    await ref.set("ping"); // Skicka upp
    await ref.remove(); // Ta bort direkt
    print("Firebase koppling: lyckades!");
  } catch (e) {
    print("Firebase koppling: misslyckades! $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationBottomBar()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        // ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
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
      home: RootPage(),
    );
  }
}
