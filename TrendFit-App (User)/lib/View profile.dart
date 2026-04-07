//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trendfitapp/Edit%20profile.dart';
//
// void main() {
//   runApp(const ViewProfile());
// }
//
// class ViewProfile extends StatelessWidget {
//   const ViewProfile({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'View Profile',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const ViewProfilePage(title: 'View Profile'),
//     );
//   }
// }
//
// class ViewProfilePage extends StatefulWidget {
//   const ViewProfilePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<ViewProfilePage> createState() => _ViewProfilePageState();
// }
//
// class _ViewProfilePageState extends State<ViewProfilePage> {
//   // User Profile Data Variables
//   String name_ = "";
//   String dob_ = "";
//   String gender_ = "";
//   String email_ = "";
//   String phone_ = "";
//   String place_ = "";
//   String post_ = "";
//   String pin_ = "";
//   String district_ = "";
//   String age_ = "";
//   String height_ = "";
//   String photo_ = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _send_data();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           leading: BackButton(),
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           title: Text(widget.title),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               // Profile Image Section
//               Center(
//                 child: CircleAvatar(
//                   radius: 70,
//                   // backgroundColor: Colors.blueAccent,
//                   child: Image.network(photo_,height: 110),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Profile Information Section
//               _buildProfileDetail('Name', name_),
//               _buildProfileDetail('Gender', gender_),
//               _buildProfileDetail('Email', email_),
//               _buildProfileDetail('Phone', phone_),
//               _buildProfileDetail('Place', place_),
//               _buildProfileDetail('Post', post_),
//               _buildProfileDetail('Pin Code', pin_),
//               _buildProfileDetail('District', district_),
//               _buildProfileDetail('age', age_),
//               _buildProfileDetail('height', height_),
//
//               const SizedBox(height: 20),
//
//               // Edit Profile Button
//               Center(
//                 child: ElevatedButton (
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Myeditprofilepage (title: "Edit Profile" ),
//                       ),
//                     );
//                   },
//                   child: const Text("Edit Profile",style: TextStyle(color: Colors.white),),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12,), backgroundColor: Colors.deepPurple,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Function to Build Profile Detail Widgets
//   Widget _buildProfileDetail(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: Row(
//         children: [
//           Text(
//             '$label: ',
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           Expanded(
//             child: Text(
//               value.isEmpty ? 'Not Available' : value,
//               style: const TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Function to Fetch Profile Data
//   void _send_data() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//     String img = sh.getString('img').toString();
//
//     final urls = Uri.parse('$url/view_profile_user/');
//     try {
//       final response = await http.post(urls, body: {'lid': lid});
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'].toString();
//         if (status == 'ok') {
//           String username = jsonDecode(response.body)['username'].toString();
//           String gender = jsonDecode(response.body)['gender'].toString();
//           String email = jsonDecode(response.body)['email'].toString();
//           String phone = jsonDecode(response.body)['phone'].toString();
//           String place = jsonDecode(response.body)['place'].toString();
//           String post = jsonDecode(response.body)['post'].toString();
//           String pincode = jsonDecode(response.body)['pincode'].toString();
//           String district = jsonDecode(response.body)['district'].toString();
//           String age = jsonDecode(response.body)['age'].toString();
//           String height = jsonDecode(response.body)['height'].toString();
//           String photo =img+ jsonDecode(response.body)['photo'].toString();
//
//           setState(() {
//             name_ = username;
//             gender_ = gender;
//             email_ = email;
//             phone_ = phone;
//             place_ = place;
//             post_ = post;
//             pin_ = pincode;
//             district_ = district;
//             age_ = age;
//             height_ = height;
//             photo_ = photo;
//           });
//         } else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
// }


// lib/main.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendfitapp/Edit%20profile.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7FBF8),
        primaryColor: const Color(0xFF0B8E45),
        fontFamily: 'Roboto',
      ),
      home: const ViewProfilePage(title: 'My Profile'),
    );
  }
}

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key, required this.title});
  final String title;
  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  // Profile fields (defaults empty)
  String name_ = "";
  String dob_ = "";
  String gender_ = "";
  String email_ = "";
  String phone_ = "";
  String place_ = "";
  String post_ = "";
  String pin_ = "";
  String district_ = "";
  String age_ = "";
  String height_ = "";
  String photo_ = "";


  final String fallbackImage = '/mnt/data/viewpro.png';

  @override
  void initState() {
    super.initState();
    _send_data();
  }

  // small helper to show "Not Available" fallback
  String _show(String s) => s.isEmpty ? 'Not Available' : s;

  Widget _labelValueRow(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 6.0),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF66B288),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _show(value),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Color(0xFF0D2118),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE6F3EA)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    final totalBottomPadding = bottomInset + 24.0;

    // determine avatar widget: prefer network photo_ else local fallback
    Widget avatarWidget() {
      final double outerRadius = 86;
      final double innerRadius = 78;
      Widget avatarImage;

      if (photo_.isNotEmpty) {
        // try using network image
        avatarImage = ClipOval(
          child: Image.network(
            photo_,
            width: innerRadius * 2,
            height: innerRadius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.file(File(fallbackImage), width: innerRadius * 2, height: innerRadius * 2, fit: BoxFit.cover),
          ),
        );
      } else if (File(fallbackImage).existsSync()) {
        avatarImage = ClipOval(
          child: Image.file(File(fallbackImage), width: innerRadius * 2, height: innerRadius * 2, fit: BoxFit.cover),
        );
      } else {
        avatarImage = CircleAvatar(radius: innerRadius, backgroundColor: Colors.grey.shade300);
      }

      return Container(
        width: outerRadius * 2,
        height: outerRadius * 2,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF9F0), // pale border color
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: innerRadius * 2,
          height: innerRadius * 2,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: avatarImage,
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async => true,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            centerTitle: true,
            backgroundColor: const Color(0xFFF7FBF8),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          backgroundColor: const Color(0xFFF7FBF8),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 0,20, totalBottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Center(
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF0D2118)),
                  ),
                ),

                // Avatar
                Center(child: avatarWidget()),

                // Name and email
                Center(
                  child: Column(
                    children: [
                      Text(
                        name_,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF0D2118)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        email_,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF67A882), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
                const Divider(height: 1, thickness: 1, color: Color(0xFFE6F3EA)),
                const SizedBox(height: 8),

                // Details list
                _labelValueRow('Age', age_),
                _labelValueRow('Height', height_),
                _labelValueRow('Gender',gender_),
                _labelValueRow('Phone', phone_ ),
                _labelValueRow('District', district_),
                _labelValueRow('Post', post_),
                _labelValueRow('Pin Code', pin_),

                const SizedBox(height: 22),

                // Edit Profile button (full width rounded)
                ElevatedButton(
                  onPressed: () {
                    // Navigate to edit page - replace with your real Edit profile page
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const  Myeditprofile(title: '')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B8E45),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 6,
                    shadowColor: Colors.black26,
                  ),
                  child: const Text('Edit Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Colors.white)),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fetch profile from server - keeps your original logic
  void _send_data() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';
      String img = sh.getString('img') ?? '';
      

      final urls = Uri.parse('$url/view_profile_user/');
      final response = await http.post(urls, body: {'lid': lid}).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final status = body['status'].toString();
        if (status == 'ok') {
          setState(() {
            name_ = body['username']?.toString() ?? '';
            gender_ = body['gender']?.toString() ?? '';
            email_ = body['email']?.toString() ?? '';
            phone_ = body['phone']?.toString() ?? '';
            place_ = body['place']?.toString() ?? '';
            post_ = body['post']?.toString() ?? '';
            pin_ = body['pincode']?.toString() ?? '';
            district_ = body['district']?.toString() ?? '';
            age_ = body['age']?.toString() ?? '';
            height_ = body['height']?.toString() ?? '';
            // combine base img path + photo if present
            final serverPhoto = body['photo']?.toString() ?? '';
            photo_ = (img.isNotEmpty && serverPhoto.isNotEmpty) ? img + serverPhoto : '';
          });
        } else {
          Fluttertoast.showToast(msg: 'Profile not found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      // set some demo data so UI is visible even on error
    }
  }
}


