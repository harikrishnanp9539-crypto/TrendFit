// import 'package:flutter/material.dart';
// import 'package:trendfitapp/View%20cart%20and%20order.dart';
// import 'package:trendfitapp/View%20dress.dart';
// import 'package:trendfitapp/pages/Aiscreen.dart';
// import 'package:trendfitapp/pages/Cart%20Page.dart';
// import 'package:trendfitapp/pages/homesrn.dart';
// import 'package:trendfitapp/pages/settingsscreen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Bottom Navigation Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       home: const BottomNavBar(),
//     );
//   }
// }
//
// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key? key}) : super(key: key);
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   int _currentIndex = 0;
//
//   final screens = [
//     const DressUpHomePage(),
//     const HomePage(),
//     const ViewCartScreen(),
//     const SettingsPage()
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.auto_awesome),
//             label: 'AI',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//           selectedItemColor: Colors.green
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:trendfitapp/View%20cart%20and%20order.dart';
import 'package:trendfitapp/View%20dress.dart';
import 'package:trendfitapp/pages/Aiscreen.dart';
import 'package:trendfitapp/pages/Cart%20Page.dart';
import 'package:trendfitapp/pages/homesrn.dart';
import 'package:trendfitapp/pages/settingsscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const BottomNavBar(), // default tab 0
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final int initialIndex;
  const BottomNavBar({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _currentIndex;

  final screens = [
    const DressUpHomePage(),
    const HomePage(),
    const ViewCartScreen(),
    const SettingsPage()
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = (widget.initialIndex >= 0 && widget.initialIndex < screens.length)
        ? widget.initialIndex
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green,
      ),
    );
  }
}
