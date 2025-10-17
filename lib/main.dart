import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'app_provider.dart';
import 'model.dart';
import 'api_getbooks.dart';

Future<void> testFirebaseConnection() async {
  try {
    final ref = FirebaseDatabase.instance.ref("testConnection");

    ref.onValue.listen((event) {
      final value = event.snapshot.value;
      print("Firebase node 'testConnection' ändrades: $value");
    });

    await ref.set("pong");
    print("Ping skickat till Firebase!");
  } catch (e) {
    print("Firebase test misslyckades: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Future.microtask(() => testFirebaseConnection());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationBottomBar()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookApp',
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
      home: const RootPage(),
    );
  }
}
