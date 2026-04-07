// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
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
//       home: const Mysendcomplaintpage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class Mysendcomplaintpage extends StatefulWidget {
//   const Mysendcomplaintpage({super.key, required this.title});
//
//
//
//   final String title;
//
//   @override
//   State<Mysendcomplaintpage> createState() => _MysendcomplaintpageState();
// }
//
// class _MysendcomplaintpageState extends State<Mysendcomplaintpage> {
//
//   TextEditingController complaintcontroller = new TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//
//         backgroundColor: Theme
//             .of(context)
//             .colorScheme
//             .inversePrimary,
//
//         title: Text(widget.title),
//       ),
//       body: Center(
//
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextFormField(controller: complaintcontroller,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(), label: Text('Complaint')),),
//             SizedBox(height: 10,),
//             ElevatedButton(onPressed: () {
//               senddata();
//             }, child: Text("Submit"))
//
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> senddata() async {
//     String complaint = complaintcontroller.text;
//
//
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//
//       final urls = Uri.parse('$url/send_complaint_user/');
//       try {
//         final response = await http.post(urls, body: {
//           'complaint':complaint,
//           'lid':lid,
//
//
//         });
//         if (response.statusCode == 200) {
//           String status = jsonDecode(response.body)['status'];
//           if (status=='ok') {
//
//             // String lid=jsonDecode(response.body)['lid'];
//             // sh.setString("lid", lid);
//             Fluttertoast.showToast(msg: 'send successfully');
//             Navigator.push(context, MaterialPageRoute(
//               builder: (context) => MyHomePage(title: "Home"),));
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
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'View reply.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complaint Submission',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Mysendcomplaintpage(title: 'Submit Complaint'),
    );
  }
}

class Mysendcomplaintpage extends StatefulWidget {
  const Mysendcomplaintpage({super.key, required this.title});

  final String title;

  @override
  State<Mysendcomplaintpage> createState() => _MysendcomplaintpageState();
}

class _MysendcomplaintpageState extends State<Mysendcomplaintpage> {
  // Controller for the complaint text field
  TextEditingController complaintcontroller = TextEditingController();

  bool _isSubmitting = false;  // For showing loading indicator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF7FBF8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Complaint text field
              TextFormField(
                controller: complaintcontroller,
                maxLines: 4,  // Allow multiple lines for the complaint
                decoration: InputDecoration(
                  labelText: 'Complaint',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : () {
                  setState(() {
                    _isSubmitting = true;  // Show loading indicator while submitting
                  });
                  senddata();
                },
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)  // Show loader
                    : const Text("Submit Complaint",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B8E45), // Button color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to send the complaint data to the server
  Future<void> senddata() async {
    String complaint = complaintcontroller.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/send_complaint_user/');
    try {
      final response = await http.post(urls, body: {
        'complaint': complaint,
        'lid': lid,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Complaint sent successfully!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ViewReplyPage(title: '',)),
          );
        } else {
          Fluttertoast.showToast(msg: 'Failed to send complaint.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() {
        _isSubmitting = false;  // Hide loading indicator after submission
      });
    }
  }
}

