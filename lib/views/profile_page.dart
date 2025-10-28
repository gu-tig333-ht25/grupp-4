import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/providers/user_provider.dart';
import 'book_info_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import '../providers/bottombar_nav.dart';
import '../models/book_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key}); // with key

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State class for ProfilePage, manages stateful data
  int selectedTab =
      0; // keeps track of which tab is active, 0: Want to read, 1: Have read

  @override
  Widget build(BuildContext context) {
    final userProvider = context
        .watch<
          UserProvider
        >(); //Important(!!!) to watch for changes from userProvider
    final colorScheme = Theme.of(context).colorScheme;

    if (userProvider.isLoading) {
      // Show loading indicator while user data is being fetched
      return const Center(child: CircularProgressIndicator());
    }

    final List<Books> currentList =
        selectedTab ==
            0 // Choose the book list based on selected tab
        ? userProvider
              .wantToRead //if
        : userProvider.haveRead; //else

    return Scaffold(
      // Main scaffold for the profile page
      appBar: AppBar(
        title: const Text(
          'Paige',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '@${userProvider.username}', // Display the username from UserProvider
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                OutlinedButton(
                  // Logout button
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error, // färg på texten (röd)
                    backgroundColor:
                        colorScheme.onError, // färg på bakgrunden (ljusröd)
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
                    // Logout functionality
                    try {
                      await FirebaseAuth.instance.signOut();

                      // Clear user data in provider after logout
                      final userProvider = context.read<UserProvider>();
                      userProvider.clearUserData();

                      // reset bottom navigation bar index, before navigating away
                      context.read<NavigationBottomBar>().setIndex(1);

                      if (context.mounted) {
                        //check if the widget is still in the widget tree, without this the app could crash if async is in progress
                        Navigator.pushReplacement(
                          //replaces the current screen with a new one
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      }
                    } catch (e) {
                      // Handle logout errors
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

            const SizedBox(
              height: 16,
            ), // Spacing below username and logout button
            // Tab buttons switching between "Want to read" and "Have read"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton(
                  label: "Want to read",
                  isSelected: selectedTab == 0,
                  onTap: () => setState(
                    () => selectedTab = 0,
                  ), // Update selected tab on tap, UI rebuilds
                  colorScheme: colorScheme,
                ),
                _buildTabButton(
                  label: "Have read",
                  isSelected: selectedTab == 1,
                  onTap: () => setState(
                    () => selectedTab = 1,
                  ), // Update selected tab on tap, UI rebuilds
                  colorScheme: colorScheme,
                ),
              ],
            ),

            const SizedBox(height: 16), // Spacing below tab buttons
            // Book list display area, expanded and scrollable
            Expanded(
              child:
                  currentList
                      .isEmpty // Show message if the list is empty
                  ? const Center(child: Text("No books in this list"))
                  : ListView.builder(
                      // Build the list of books
                      itemCount: currentList
                          .length, // Number of books in the current list
                      itemBuilder: (context, index) {
                        final book =
                            currentList[index]; // Get the book at the current index
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: OutlinedButton(
                            // Each book is an outlined button
                            onPressed: () {
                              // Navigate to book details page on tap
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookPage(book: book),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              // Styling for the book button
                              backgroundColor: Colors.grey[200],
                              side: BorderSide(color: colorScheme.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16),
                              minimumSize: const Size.fromHeight(140),
                            ),
                            child: Row(
                              // Layout for book cover, title, author, and delete button
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // Book cover image
                                  width: 60,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(book.coverUrl),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ), // Spacing between image and text
                                Expanded(
                                  // Title and author text
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book.title, // Display book title
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        book.author, // Display book author
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  // Delete button to remove book from list
                                  icon: const Icon(Icons.delete),
                                  iconSize: 30,
                                  color: colorScheme.secondary,
                                  onPressed: () async {
                                    //logic
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
    //blueprint for tab buttons to avoid code duplication
    required String label, //text on the button
    required bool isSelected, //if the button is selected
    required VoidCallback onTap, //function when tapped
    required ColorScheme colorScheme,
  }) {
    return OutlinedButton(
      // Tab button widget
      onPressed: onTap, // Call the provided onTap function when pressed
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        side: BorderSide(
          //color changes based on selection
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        //text label
        label,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
