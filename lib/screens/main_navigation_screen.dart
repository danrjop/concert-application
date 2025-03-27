import 'package:flutter/material.dart';
import 'index.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Main Navigation Screens
  final List<Widget> _screens = [
    const HomeScreen(),  
    const SearchScreen(),
    const RecordScreen(),
    const MemoriesScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.blueGrey,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            backgroundColor: Colors.blueGrey,
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.record_voice_over),
            backgroundColor: Colors.blueGrey,
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            backgroundColor: Colors.blueGrey,
            label: 'Memories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            backgroundColor: Colors.blueGrey,
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
      ),
    );
  }
}
