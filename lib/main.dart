import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'app_provider.dart';
import 'model.dart';
import 'api_getbooks.dart';

/// Logga in automatiskt med testkonto
Future<User?> loginTestUser() async {
  try {
    const email = "wilma@example.com";  // ersätt med ert testkonto
    const password = "test1234";        // ersätt med lösenord

    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    print("Inloggad som ${cred.user?.email} (UID: ${cred.user?.uid})");
    return cred.user;
  } catch (e) {
    print("Inloggning misslyckades: $e");
    return null;
  }
}

/// Testar att skriva och läsa användardata i Realtime Database
Future<void> testUserData(User user) async {
  try {
    final db = FirebaseDatabase.instance.ref("users/${user.uid}");

    await db.set({
      "name": "Wilma Test",
      "email": user.email,
      "wantToRead": ["book_001", "book_002"],
      "haveRead": ["book_003"]
    });

    final snapshot = await db.get();
    if (snapshot.exists) {
      print("Hämtad användardata:");
      print(snapshot.value);
    } else {
      print("Ingen data hittades!");
    }
  } catch (e) {
    print("Fel vid testUserData: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Logga in testkonto
  final user = await loginTestUser();
  if (user == null) {
    print("Kan inte fortsätta utan inloggning!");
    return;
  }

  await testUserData(user);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationBottomBar()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        //ChangeNotifierProvider(create: (_) => UserProvider()),
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
