import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/user_provider.dart';
import 'book_info_page.dart';
import 'model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'app_provider.dart';

class ProfilePage extends StatefulWidget {
  final String username = "musicwilma";

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTab = 0;

  List<Books> wantToReadBooks = [];
  List<Books> haveReadBooks = [];

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Books> currentList = selectedTab == 0
        ? userProvider.wantToRead
        : userProvider.haveRead;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Namn',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '@${userProvider.username}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error, // färg på texten (röd)
                    backgroundColor: colorScheme
                        .onError, // färg på bakgrund (kontrastfärg till röd)
                    side: BorderSide(color: colorScheme.error), // röd kant
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();

                      // Clear user data in provider via the provider method
                      final up = context.read<UserProvider>();
                      up.clearUserData();

                      // Optional: reset bottom navigation to Home
                      context.read<NavigationBottomBar>().setIndex(1);

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      }
                    } catch (e) {
                      // Hantera logout error
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Logout failed: $e')),
                        );
                      }
                    }
                  },
                  child: const Text("Log out"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tabbar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton(
                  label: "Want to read",
                  isSelected: selectedTab == 0,
                  onTap: () => setState(() => selectedTab = 0),
                  colorScheme: colorScheme,
                ),
                _buildTabButton(
                  label: "Have read",
                  isSelected: selectedTab == 1,
                  onTap: () => setState(() => selectedTab = 1),
                  colorScheme: colorScheme,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Boklistan
            Expanded(
              child: currentList.isEmpty
                  ? const Center(child: Text("No books in this list"))
                  : ListView.builder(
                      itemCount: currentList.length,
                      itemBuilder: (context, index) {
                        final book = currentList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookPage(book: book),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              side: BorderSide(color: colorScheme.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16),
                              minimumSize: const Size.fromHeight(140),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(book.coverUrl),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book.title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        book.author,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  iconSize: 30,
                                  color: colorScheme.secondary,
                                  onPressed: () async {
                                    await userProvider.removeBook(
                                      book,
                                      selectedTab,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
