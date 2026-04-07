// lib/main.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:trendfitapp/Send%20review.dart';
import 'package:trendfitapp/View%20dress.dart';
import 'package:trendfitapp/View%20profile.dart';
import 'package:trendfitapp/change%20password.dart';
import 'package:trendfitapp/pages/test.dart';
import 'package:trendfitapp/view%20body%20measurement.dart';

import '../Add my dress.dart';
import '../View my dress.dart';
import '../View reply.dart';
import '../login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F9F7),
        primaryColor: const Color(0xFF08C36A),
        fontFamily: 'Roboto',
      ),
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // toggles state
  bool notificationsOn = true;
  bool darkModeOn = false;

  // bottom nav state
  int _selectedIndex = 3;

  // Local uploaded screenshot path (provided with your upload)
  // Use this path if you want to preview the uploaded image inside the app.

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, bottom: 10.0, top: 18.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2F3B35),
        ),
      ),
    );
  }

  Widget _roundedTile({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // subtle top/bottom separators are handled inside with Dividers
      ),
      child: child,
    );
  }

  Widget _listRow({required Widget leading, required String title, Widget? trailing, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF0D1B12)),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // safe bottom + extra space to avoid overlap
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    final totalBottomPadding = bottomInset + 24.0;

    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(18, 20, 18, totalBottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title centered
              const Center(
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF16261B)),
                ),
              ),

              // Account section
              _sectionTitle('Account'),
              _roundedTile(
                child: Column(
                  children: [
                    _listRow(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEFFCF0), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.person_outline, color: Color(0xFF149B0C)),
                      ),
                      title: 'My Profile',
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA6A0)),
                      onTap: () {

                        Navigator.push(context,MaterialPageRoute(builder: (context) => ViewProfilePage(title: ''),));
                        // navigate or action
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F6F0)),
                    _listRow(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEFFCF0), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.credit_card, color: Color(0xFF149B0C)),
                      ),
                      title: 'Change Password',
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA6A0)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyChangepasswordpage()),
                        );

                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F6F0)),
                    _listRow(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEFFCF0), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.location_on_outlined, color: Color(0xFF149B0C)),
                      ),
                      title: 'Body measurements',
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA6A0)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => myViewMeasurement(title: ''),));
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F6F0)),
                    _listRow(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEFFCF0), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.credit_card, color: Color(0xFF149B0C)),
                      ),
                      title: 'Add own dress',
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA6A0)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddMyDressPage()),
                        );

                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F6F0)),
                    _listRow(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEFFCF0), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.credit_card, color: Color(0xFF149B0C)),
                      ),
                      title: 'View own dress',
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA6A0)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyViewmydresspage(title:''),));
                      },
                    ),
                  ],
                ),
              ),


              // Support section
              _sectionTitle('Support'),
              _roundedTile(
                child: Column(
                  children: [
                    _listRow(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEFFCF0), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.help_outline, color: Color(0xFF149B0C)),
                      ),
                      title: 'Help & FAQ',
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA6A0)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewReplyPage(title: '',),));
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F6F0)),
                    _listRow(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEFFCF0), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.info_outline, color: Color(0xFF149B0C)),
                      ),
                      title: 'Rate Us',
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA6A0)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Mysendreviewpage(title: ''),));
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Logout button full width rounded pale green
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Myloginpage(title: '',),));
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),

              const SizedBox(height: 36), // extra space before bottom nav
            ],
          ),
        ),
      ),
    );
  }
}
