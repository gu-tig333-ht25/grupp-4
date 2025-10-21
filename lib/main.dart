import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'app_provider.dart';
import 'model.dart';
import 'api_getbooks.dart';
import 'user_provider.dart';
import 'login_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'tag_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => NavigationBottomBar()),
        ChangeNotifierProvider(create: (_) => TagProvider()),
      ],
      child: MaterialApp(
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
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user != null) {
          // ensure provider loads fresh data when user is signed in
          Future.microtask(() => context.read<UserProvider>().loadUserData());
          return const RootPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
