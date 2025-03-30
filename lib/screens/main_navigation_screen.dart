import 'package:flutter/material.dart';
import 'index.dart';
import '../widgets/app_drawer.dart';
import '../constants/app_constants.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  MainNavigationScreenState createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Main Navigation Screens
  // Main Navigation Screens
  final List<Widget> _screens = [
    const HomeScreen(),  
    const SearchScreen(),
    const RecordScreen(),
    const MemoriesScreen(),
    const ProfileScreen(),
  ];
  
  // Used to navigate to a specific tab in the memories screen
  static int? memoriesTabToSelect;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void openSidebar() {
    _scaffoldKey.currentState?.openEndDrawer();
  }
  
  // Method to navigate to memories screen and select a specific tab
  void navigateToMemoriesWithTab(int tabIndex) {
    MainNavigationScreenState.memoriesTabToSelect = tabIndex;
    onItemTapped(3); // Index 3 is the memories screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(currentIndex: _selectedIndex),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // Add a top border or shadow for iOS style appearance
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Colors.grey.shade300,
              width: 0.5
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'Record',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_outlined),
              activeIcon: Icon(Icons.photo),
              label: 'Memories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppConstants.darkBackgroundColor
              : Colors.white,
          elevation: 0,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
