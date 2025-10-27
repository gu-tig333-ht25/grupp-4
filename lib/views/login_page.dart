import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/rootpage.dart';
import '../providers/bottombar_nav.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController usernameController =
      TextEditingController(); // Receives users Email
  final TextEditingController passwordController =
      TextEditingController(); // Receives users Password

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Paige",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email input
            TextField(
              controller: usernameController, // Stores text input
              decoration: InputDecoration(
                labelText:
                    'Email', // Displays the label “Email” inside the field
                prefixIcon: const Icon(Icons.person), // Icon on the left
                filled: true,
                fillColor: colorScheme.primaryContainer.withAlpha(20),
                focusedBorder: OutlineInputBorder(
                  // Border style and color when the field is active
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  // Border style and color when the field is inactive
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password input
            TextField(
              controller: passwordController, // Stores text input
              obscureText: true, // Hides the entered text for privacy
              decoration: InputDecoration(
                labelText:
                    'Password', // Displays the label “Password” inside the field
                prefixIcon: const Icon(Icons.lock), // Icon on the left
                filled: true,
                fillColor: colorScheme.primaryContainer.withAlpha(20),
                focusedBorder: OutlineInputBorder(
                  // Border style and color when the field is active
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  // Border style and color when the field is inactive
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login-button
            SizedBox(
              width: double
                  .infinity, // Makes the button expand to full available width inside the Column
              child: ElevatedButton(
                onPressed: () async {
                  // Get user input from the text fields
                  final email = usernameController.text.trim();
                  final password = passwordController.text;

                  if (email.isEmpty || password.isEmpty) {
                    // OR condition: show message if either email or password is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter email and password')),
                    );
                    return;
                  }

                  // Try signing in with fierbase
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // Stop if the page is no longer active
                    if (!context.mounted) return;

                    // Load the user's data
                    await context.read<UserProvider>().loadUserData();

                    // Stop if the page is no longer active
                    if (!context.mounted) return;

                    // Set the active view in the bottom navigation bar to index 1 (home)
                    context.read<NavigationBottomBar>().setIndex(1);

                    // Stop if the page is no longer active
                    if (!context.mounted) return;

                    // Navigate to RootPage and replace the current login view
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RootPage()),
                    );
                  } on FirebaseAuthException catch (e) {
                    // Handles Firebase login errors
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message ?? 'Login failed')),
                    );
                  } catch (e) {
                    // Handles any other unexpected errors
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
