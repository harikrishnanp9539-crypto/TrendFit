// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'Delivery boy/home.dart';
// import 'Home.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const Myloginpage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class Myloginpage extends StatefulWidget {
//   const Myloginpage({super.key, required this.title});
//
//
//
//   final String title;
//
//   @override
//   State<Myloginpage> createState() => _MyloginpageState();
// }
//
// class _MyloginpageState extends State<Myloginpage> {
//
//   TextEditingController usernamecontroller=new TextEditingController();
//   TextEditingController passwordcontroller=new TextEditingController();
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//
//         title: Text(widget.title),
//       ),
//       body: Center(
//
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//
//             TextFormField(controller:usernamecontroller,decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Enter the username')),),
//             TextFormField(controller:passwordcontroller,decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Enter the password')),),
//             SizedBox(height: 10,),
//             ElevatedButton(onPressed: (){
//
//
//
//               senddata();
//             }, child: Text("Submit"))
//
//
//
//
//
//           ],
//         ),
//       ),
//     );
//   }
//   Future<void> senddata() async {
//     String username=usernamecontroller.text;
//     String password=passwordcontroller.text;
//
//
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url').toString();
//
//       final urls = Uri.parse('$url/login_flutt/');
//       try {
//         final response = await http.post(urls, body: {
//           'username':username,
//           'password':password,
//
//
//         });
//         if (response.statusCode == 200) {
//           String status = jsonDecode(response.body)['status'].toString();
//           String type = jsonDecode(response.body)['type'].toString();
//           if (status=='ok') {
//
//             String lid=jsonDecode(response.body)['lid'].toString();
//             sh.setString("lid", lid);
//
//             if(type == "user"){
//
//               Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => MyHomePage(title: "Home"),));
//
//             }
//             else if(type == "deliveryboy"){
//               Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => DelvyHomePage(title: 'Home',),));
//             }
//           }else {
//             Fluttertoast.showToast(msg: 'Not Found');
//           }
//         }
//         else {
//           Fluttertoast.showToast(msg: 'Network Error');
//         }
//       }
//       catch (e){
//         Fluttertoast.showToast(msg: e.toString());
//       }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:trendfitapp/pages/bottomnavigationbar.dart';
import 'package:trendfitapp/sign%20up.dart';

import 'Delivery boy/home.dart';
import 'Home.dart';
import 'forgot_password.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Myloginpage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Myloginpage extends StatefulWidget {
  const Myloginpage({super.key, required this.title});

  final String title;

  @override
  State<Myloginpage> createState() => _MyloginpageState();
}

class _MyloginpageState extends State<Myloginpage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Logo or Title (optional)
                  Image.asset(
                    'assets/img/applogo.png',
                    height: 120, // adjust size as needed
                  ),
                  const SizedBox(height: 20),

                  Text(
                    "Welcome Back!",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF149B0C),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Username Field
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Enter the username',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter the password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Mysignuppage(title: "sign up"),));


                        },
                        child: Text(
                          "Don't have an account?",
                          style: TextStyle(color: const Color(0xFF149B0C)),
                        ),
                      ),
                      const SizedBox(width: 68,),
                      Align(
                        alignment: Alignment.centerRight,
                        child:TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => forgot_password(),));


                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: const Color(0xFF149B0C)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 05),

                  // Submit Button
                  ElevatedButton(
                    onPressed: sendData,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), backgroundColor: Colors.green, // Full width
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ), // Button color
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 18 ,color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Other options like forgot password or sign up link

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendData() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all fields');
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    final urls = Uri.parse('$url/login_flutt/');

    try {
      final response = await http.post(urls, body: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'].toString();
        String type = jsonDecode(response.body)['type'].toString();
        if (status == 'ok') {
          String lid = jsonDecode(response.body)['lid'].toString();
          sh.setString("lid", lid);

          if (type == "user") {
            Navigator.push(
              context,
              // MaterialPageRoute(builder: (context) => MyHomePage(title: "Home")),
              MaterialPageRoute(builder: (context) => BottomNavBar()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DelvyHomePage(title: 'Home')),
            );
          }
        } else {
          Fluttertoast.showToast(msg: 'Invalid username or password');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
