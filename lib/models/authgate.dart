import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/rootpage.dart';
import '../providers/user_provider.dart';
import '../views/login_page.dart';

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
