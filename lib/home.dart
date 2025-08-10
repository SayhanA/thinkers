import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0; // <-- Add this line

  void _onItemTapped(int index) {
    if (index == 1) {
      // Assuming login is at index 2
      Navigator.pushNamed(context, '/login');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thinkers',
          style: TextStyle(color: Color(0xFF6C63FF)),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_a_photo, color: Color(0xFF6C63FF)),
          ),
        ],
      ),
      body: Center(child: const Text('This is home page')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
            activeIcon: Icon(Icons.login, color: Color(0xFF6C63FF)),
          ),
        ],
      ),
    );
  }
}
