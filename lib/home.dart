import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      setState(() {
        _user = jsonDecode(userString);
      });
    } else {
      setState(() => _user = null);
    }
  }

  void _onItemTapped(int index) async {
    if (index == 1) {
      if (_user != null) {
        // Logout
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('user');
        setState(() => _user = null);
      } else {
        // Go to login page and refresh after return
        await Navigator.pushNamed(context, '/login');
        _loadUser();
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultImage =
        "https://images.unsplash.com/photo-1633332755192-727a05c4013d?fm=jpg&q=60&w=3000";

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
      body: Center(
        child: _user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      _user!['user']?['image'] ?? defaultImage,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _user!['user']?['name'] ?? '',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _user!['user']?['email'] ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              )
            : const Text('This is home page'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(_user != null ? Icons.logout : Icons.login),
            label: _user != null ? 'Logout' : 'Login',
            activeIcon: Icon(
              _user != null ? Icons.logout : Icons.login,
              color: const Color(0xFF6C63FF),
            ),
          ),
        ],
      ),
    );
  }
}
