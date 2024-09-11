import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'home_content_screen.dart'; // Import other screen files
import 'channels_screen.dart';
import 'playlists_screen.dart';
import 'videos_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "settings") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: "settings",
                child: Text("Settings"),
              ),
            ],
          ),
        ],
      ),
      body: _buildScreen(_currentIndex), // Display the selected screen
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blue, // Set the background color
          primaryColor: Colors.white, // Set the selected item color
          textTheme: Theme.of(context).textTheme.copyWith(
            labelSmall: const TextStyle(color: Colors.white), // Set the unselected item color (Use labelSmall for newer Flutter versions)
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions), // Icon representing channels
              label: "Channels",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.playlist_play),
              label: "Playlists",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ondemand_video), // Icon representing individual videos
              label: "Videos",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeContentScreen();
      case 1:
        return ChannelsScreen();
      case 2:
        return PlaylistsScreen();
      case 3:
        return VideosScreen();
      default:
        return Container();
    }
  }
}