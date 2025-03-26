import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mqrktkviabljvjktpaox.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1xcmt0a3ZpYWJsanZqa3RwYW94Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI5NTEzNDUsImV4cCI6MjA1ODUyNzM0NX0.ntNWeUCWepaILWS_Tt96ygxKmhkjHY67vL8VQv0VDNQ',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Concert Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ), 
      home: MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Main Navigation Screens
  final List<Widget> _screens = [
    HomeScreen(),  
    SearchScreen(),
    RecordScreen(),
    MemoriesScreen(),
    ProfileScreen(),
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Center(
        child: Text('Search Screen'),
      ),
    );
  }
}

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record'),
      ),
      body: Center(
        child: Text('Record Screen'),
      ),
    );
  }
}

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memories'),
      ),
      body: Center(
        child: Text('Memories Screen'),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State variable for tab selection
  bool isRecentActivitySelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Name', style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {
              // TODO: Implement add functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu_outlined),
            onPressed: () {
              // TODO: Implement menu functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile section with image and stats side by side
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              children: [
                // Display name at the top
                const Text(
                  'Display Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                
                const SizedBox(height: 16),
                
                // Profile picture and stats in row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Profile picture
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/flower.png'), // Replace with actual image
                    ),
                    
                    // Stats columns
                    Column(
                      children: const [
                        Text(
                          '100',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('Followers'),
                      ],
                    ),
                    
                    Column(
                      children: const [
                        Text(
                          '100',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('Following'),
                      ],
                    ),
                    
                    Column(
                      children: const [
                        Text(
                          '# 100',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('Rank'),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Edit Profile and Share Profile buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Edit Profile Button
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement edit profile functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                    
                    const SizedBox(width: 15), // Spacing between buttons
                    
                    // Share Profile Button
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Implement share profile functionality
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blueGrey,
                        side: const BorderSide(color: Colors.blueGrey),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Share Profile'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Divider
          const Divider(height: 1, thickness: 1),
          
          // Been list item
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('Been'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to Been page
            },
          ),
          
          // Divider
          const Divider(height: 1, thickness: 1),
          
          // Bookmarks list item
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text('Bookmarks'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to Bookmarks page
            },
          ),
          
          // Divider
          const Divider(height: 1, thickness: 1),
          
          // Tab switch navigation between Recent Activity and Taste Profile
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Segmented control for tab switching
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // Recent Activity tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isRecentActivitySelected = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isRecentActivitySelected 
                                  ? Colors.white 
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isRecentActivitySelected 
                                  ? [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ] 
                                  : null,
                            ),
                            child: const Center(
                              child: Text(
                                'Recent Activity',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Taste Profile tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isRecentActivitySelected = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isRecentActivitySelected 
                                  ? Colors.white 
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: !isRecentActivitySelected 
                                  ? [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ] 
                                  : null,
                            ),
                            child: const Center(
                              child: Text(
                                'Taste Profile',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content area that changes based on selected tab
                Container(
                  height: 200, // Adjust height as needed
                  margin: const EdgeInsets.only(top: 16),
                  child: isRecentActivitySelected
                      ? const Center(
                          child: Text('Recent Activity Content'),
                        )
                      : const Center(
                          child: Text('Taste Profile Content'),
                        ),
                ),
              ],
            ),
          ),
          
          // Spacer to push the home indicator to the bottom
          const Spacer(),
          
          // Home indicator
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

