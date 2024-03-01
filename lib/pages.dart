import 'package:flutter/material.dart';

import 'homepage.dart';
import 'trash_page.dart';

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int selectedIndex = 0;
  Color actionButtonColor = const Color(0xffc99180);
  final List<Widget> _pages = const [
    HomePage(),
    TrashPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical:5.0),
            child: CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2023/07/23/20/09/female-8145765_1280.jpg',
              ),
            ),
          ),
        ],
      ),
      body: _pages.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: actionButtonColor,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit_document), label: "Notes"),
          BottomNavigationBarItem(icon: Icon(Icons.delete), label: "Trash"),
        ],
        ),
    );
  }
}