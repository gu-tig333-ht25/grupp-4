import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String username = "musicwilma";

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTab = 0;

  List<String> wantToReadBooks = ["Bok A", "Bok B", "Bok C"];
  List<String> haveReadBooks = [
    "Bok 1",
    "Bok 2",
    "Bok 3",
    "Bok 4",
    "Bok 5",
    "Bok 6",
    "Bok 7",
    "Bok 8"
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    List<String> currentList =
        selectedTab == 0 ? wantToReadBooks : haveReadBooks;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Översta raden: username + log out
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '@${widget.username}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              // Log out-knappen
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.error),
                  foregroundColor: colorScheme.error,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ).copyWith(
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                      if (states.contains(WidgetState.hovered) ||
                          states.contains(WidgetState.pressed)) {
                        return colorScheme.error.withValues(alpha: 0.1);
                      }
                      return null;
                    },
                  ),
                ),
                child: Text(
                  "Log out",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Flik-knappar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTabButton(
                  label: "Want to read",
                  isSelected: selectedTab == 0,
                  onTap: () => setState(() => selectedTab = 0),
                  colorScheme: colorScheme),
              _buildTabButton(
                  label: "Have read",
                  isSelected: selectedTab == 1,
                  onTap: () => setState(() => selectedTab = 1),
                  colorScheme: colorScheme),
            ],
          ),

          const SizedBox(height: 16),

          // Boklista
          Expanded(
            child: currentList.isEmpty
                ? Center(
                    child: Text(
                      "Inga böcker här än!",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.grey[200], // ljusgrå
                            side: BorderSide(
                              color: colorScheme.primary,
                            ),
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
                                color: Colors.grey[300],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //titel och författare
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentList[index],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Författare",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //taggar till höger
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "#tagg1  #tagg2",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
        backgroundColor:
            isSelected ? colorScheme.primaryContainer : Colors.white,
        side: BorderSide(color: colorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
