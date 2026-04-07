// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trendfitapp/Home.dart';
// import 'package:trendfitapp/login.dart';
// import 'Home.dart';
//
//
// void main() {
//   runApp(const MyChangepasswordpage());
// }
//
// class MyChangepasswordpage extends StatelessWidget {
//   const MyChangepasswordpage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Change Password',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyChangePasswordPage(title: 'Change Password'),
//     );
//   }
// }
//
// class MyChangePasswordPage extends StatefulWidget {
//   const MyChangePasswordPage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyChangePasswordPage> createState() => _MyChangePasswordPageState();
// }
//
// class _MyChangePasswordPageState extends State<MyChangePasswordPage> {
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     TextEditingController oldpasswordController= new TextEditingController();
//     TextEditingController newpasswordController= new TextEditingController();
//     TextEditingController confirmpasswordController= new TextEditingController();
//
//
//     return WillPopScope(
//       onWillPop: () async{ return true; },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           title: Text(widget.title),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   controller: oldpasswordController,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Old Password")),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                  controller: newpasswordController,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("New Password")),
//                 ),
//               ),      Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                  controller: confirmpasswordController,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Confirm Password")),
//                 ),
//               ),
//
//               ElevatedButton(
//                 onPressed: () async {
//
//                   String oldp= oldpasswordController.text.toString();
//                   String newp= newpasswordController.text.toString();
//                   String confp= confirmpasswordController.text.toString();
//
//
//
//                   SharedPreferences sh = await SharedPreferences.getInstance();
//                   String url = sh.getString('url').toString();
//                   String lid = sh.getString('lid').toString();
//
//                   final urls = Uri.parse('$url/user_Change_password_post/');
//                   try {
//                     final response = await http.post(urls, body: {
//                       'textfield':oldp,
//                       'textfield2':newp,
//                       'textfield3':confp,
//                       'lid':lid,
//
//
//
//                     });
//                     if (response.statusCode == 200) {
//                       String status = jsonDecode(response.body)['status'];
//                       if (status=='ok') {
//
//
//
//
//                         Fluttertoast.showToast(msg: 'Password Changed Successfully');
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => Myloginpage(title: 'Login',)));
//                       }else {
//                         Fluttertoast.showToast(msg: 'Incorrect Password');
//                       }
//                     }
//                     else {
//                       Fluttertoast.showToast(msg: 'Network Error');
//                     }
//                   }
//                   catch (e){
//                     Fluttertoast.showToast(msg: e.toString());
//                   }
//
//                 },
//                 child: Text("ChangePassword"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendfitapp/Home.dart';
import 'package:trendfitapp/login.dart';
import 'package:trendfitapp/pages/bottomnavigationbar.dart';

void main() {
  runApp(const MyChangepasswordpage());
}

class MyChangepasswordpage extends StatelessWidget {
  const MyChangepasswordpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Change Password',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyChangePasswordPage(title: 'Change Password'),
    );
  }
}

class MyChangePasswordPage extends StatefulWidget {
  const MyChangePasswordPage({super.key, required this.title});

  final String title;

  @override
  State<MyChangePasswordPage> createState() => _MyChangePasswordPageState();
}

class _MyChangePasswordPageState extends State<MyChangePasswordPage> {
  // Controllers for text fields
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>BottomNavBar(initialIndex: 3),));
            },
          ),
          title: const Text(
            'Change Password',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Card Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Old Password
                      _buildPasswordField(
                        label: "Old Password",
                        controller: oldpasswordController,
                        obscureText: true,
                        icon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 20),

                      // New Password
                      _buildPasswordField(
                        label: "New Password",
                        controller: newpasswordController,
                        obscureText: true,
                        icon: Icons.lock_reset,
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password
                      _buildPasswordField(
                        label: "Confirm Password",
                        controller: confirmpasswordController,
                        obscureText: true,
                        icon: Icons.verified_user_outlined,
                      ),
                      const SizedBox(height: 35),

                      // Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _changePassword,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF2DD376),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            "Change Password",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF2DD376)),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Change Password Function
  Future<void> _changePassword() async {
    String oldp = oldpasswordController.text.toString();
    String newp = newpasswordController.text.toString();
    String confp = confirmpasswordController.text.toString();

    if (newp != confp) {
      Fluttertoast.showToast(msg: "New password and confirm password don't match!");
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/user_Change_password_post/');
    try {
      final response = await http.post(urls, body: {
        'current_password': oldp,
        'new_password': newp,
        'confirm_password': confp,
        'lid': lid,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Password Changed Successfully');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Myloginpage(title: 'Login')),
          );
        } else {
          Fluttertoast.showToast(msg: 'Incorrect Password');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}