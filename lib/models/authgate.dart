import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/rootpage.dart';
import '../providers/user_provider.dart';
import '../views/login_page.dart';

// Listens to Firebase authentication state changes
// and shows either the active rootpage (signed in) or the login page (not signed in)
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Updates everytime user's sign in status changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data; // Holds the active user or null
        if (user != null) {
          // Loads user's data if it's signed in and shows active rootpage
          Future.microtask(() => context.read<UserProvider>().loadUserData());
          return const RootPage();
        } else {
          // user = null, shows login page
          return LoginPage();
        }
      },
    );
  }
}
