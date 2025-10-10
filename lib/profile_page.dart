import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String username = "musicwilma";

  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTab = 0;

  //Standin när det inte finns riktiga listor
  List<String> wantToReadBooks = ["Bok A", "Bok B", "Bok C"];
  List<String> haveReadBooks = ["Bok 1", "Bok 2", "Bok 3", "Bok 4", "Bok 5", "Bok 6", "Bok 7", "Bok 8"];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    //lista som visas beroende på aktiv knapp
    List<String> currentList =
        selectedTab == 0 ? wantToReadBooks : haveReadBooks;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //översta raden: username + log out
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
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.error),
                ),
                child: Text(
                  "Log out",
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          //flik-knappar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTabButton(
                label: "Want to read",
                isSelected: selectedTab == 0,
                onTap: () {
                  setState(() {
                    selectedTab = 0;
                  });
                },
                colorScheme: colorScheme,
              ),
              _buildTabButton(
                label: "Have read",
                isSelected: selectedTab == 1,
                onTap: () {
                  setState(() {
                    selectedTab = 1;
                  });
                },
                colorScheme: colorScheme,
              ),
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
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 70,
                            color: Colors.grey[300],
                          ),
                          title: Text(currentList[index]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Författare"),
                              const SizedBox(height: 4),
                              Text(
                                "#tagg1  #tagg2",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
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

  // Bygger en flik-knapp med tema-färger
  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isSelected ? colorScheme.primaryContainer : Colors.white,
        side: BorderSide(
          color: isSelected ? colorScheme.primary : Colors.grey,
        ),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? colorScheme.primary : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
