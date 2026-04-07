// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'Home.dart';
// import 'login.dart';
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
//       home: const MyMainPage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyMainPage extends StatefulWidget {
//   const MyMainPage({super.key, required this.title});
//
//
//
//   final String title;
//
//   @override
//   State<MyMainPage> createState() => _MyMainPageState();
// }
//
// class _MyMainPageState extends State<MyMainPage> {
//
//   TextEditingController ipcontroller=new TextEditingController();
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
//
//             TextFormField(controller:ipcontroller,decoration: InputDecoration(border: OutlineInputBorder(),label: Text('enter ip address')),),
//             SizedBox(height: 10,),
//             ElevatedButton(onPressed: (){
//               senddata();
//             }, child: Text("connect"))
//
//
//
//           ],
//         ),
//
//       ),
//     );
//   }
//
//   Future<void> senddata() async {
//     String ip=ipcontroller.text;
//
//
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url="http://"+ip+":8000/myapp";
//       String img="http://"+ip+":8000/";
//       sh.setString('url', url).toString();
//       sh.setString('img', img).toString();
//       Navigator.push(context, MaterialPageRoute(builder: (context)=>Myloginpage(title: 'Login',)));
//
//
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Home.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP Connect App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyMainPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key, required this.title});

  final String title;

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  TextEditingController ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Heading
                Text(
                  'Enter Server IP Address',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 40),

                // IP Address Input Field
                TextFormField(
                  controller: ipController,
                  decoration: InputDecoration(
                    labelText: 'Enter IP Address',
                    prefixIcon: Icon(Icons.wifi),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Connect Button
                ElevatedButton(
                  onPressed: sendData,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), backgroundColor: Colors.deepPurple, // Full width button
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ), // Button color
                  ),
                  child: Text (
                    'Connect',
                    style: TextStyle(fontSize: 18,color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendData() async {
    String ip = ipController.text;

    if (ip.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter a valid IP address');
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = "http://$ip:9001/myapp";
    String img = "http://$ip:9001";

    sh.setString('url', url);
    sh.setString('img', img);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Myloginpage(title: 'Login')),
    );
  }
}

