//
// import 'dart:convert';
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
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
//       title: 'Flutter Demo',debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const DressCombinations(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class DressCombinations extends StatefulWidget {
//   const DressCombinations({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<DressCombinations> createState() => _DressCombinationsState();
// }
//
// class _DressCombinationsState extends State<DressCombinations> {
//
//   _DressCombinationsState() {
//     view_notification();
//   }
//
//   List<String> bottom_ = <String>[];
//   List<String> top_ = <String>[];
//
//
//
//   Future<void> view_notification() async {
//     List<String> bottom = <String>[];
//     List<String> top= <String>[];
//
//
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String img_url = sh.getString('img').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/user_dress_combinations/';
//
//       var data = await http.post(Uri.parse(url), body: {
//         'lid':lid
//
//
//       });
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//
//       var arr = jsondata["data"];
//
//       print(arr.length);
//
//       for (int i = 0; i < arr.length; i++) {
//
//         bottom.add(img_url+arr[i]['bottom'].toString());
//         top.add(img_url+arr[i]['top'].toString());
//
//
//       }
//
//       setState(() {
//         bottom_ = bottom;
//         top_=top;
//
//       });
//
//       print(statuss);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//       //there is error during converting file image to base64 encoding.
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//         appBar: AppBar(
//           leading: BackButton( ),
//           // TRY THIS: Try changing the color here to a specific color (to
//           // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//           // change color while the other colors stay the same.
//           backgroundColor: Theme.of(context).colorScheme.primary,
//
//           title: Text(widget.title),
//         ),
//         body: ListView.builder(
//           physics: BouncingScrollPhysics(),
//           // padding: EdgeInsets.all(5.0),
//           // shrinkWrap: true,
//           itemCount: bottom_.length,
//           itemBuilder: (BuildContext context, int index) {
//             return ListTile(
//               onLongPress: () {
//                 print("long press" + index.toString());
//               },
//               title: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       Card(
//                         child:
//                         Row(
//                             children: [
//                               CircleAvatar(radius: 50,backgroundImage: NetworkImage(top_[index])),
//                               CircleAvatar(radius: 50,backgroundImage: NetworkImage(bottom_[index])),
//
//                             ]
//                         )
//
//                         ,
//                         elevation: 8,
//                         margin: EdgeInsets.all(10),
//                       ),
//                     ],
//                   )),
//             );
//           },
//         )
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const DressCombinations(title: 'Dress Combinations'),
    );
  }
}

class DressCombinations extends StatefulWidget {
  const DressCombinations({super.key, required this.title});

  final String title;

  @override
  State<DressCombinations> createState() => _DressCombinationsState();
}

class _DressCombinationsState extends State<DressCombinations> {
  _DressCombinationsState() {
    view_notification();
  }

  List<String> bottom_ = <String>[];
  List<String> top_ = <String>[];
  bool isLoading = true;

  Future<void> view_notification() async {
    List<String> bottom = <String>[];
    List<String> top = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String img_url = sh.getString('img').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/user_dress_combinations/';

      var data = await http.post(Uri.parse(url), body: {
        'lid': lid
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        bottom.add(img_url + arr[i]['bottom'].toString());
        top.add(img_url + arr[i]['top'].toString());
      }

      setState(() {
        bottom_ = bottom;
        top_ = top;
        isLoading = false;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).maybePop()),
        centerTitle: true,
        title: const Text(
          'Dress Combination',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
      ),
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.green,
              strokeWidth: 4,
            ),
            SizedBox(height: 20),
            Text(
              'Loading your combinations...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF149B0C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : bottom_.isEmpty
          ? Center(
        child: Text(
          'No dress combinations found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      )
          : ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: bottom_.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onLongPress: () {
              print("long press" + index.toString());
            },
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8,
                margin: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Topwear section
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Topwear',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(top_[index]),
                              backgroundColor: Colors.grey[200],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      // Bottomwear section
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Bottomwear',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(bottom_[index]),
                              backgroundColor: Colors.grey[200],
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
        },
      ),
    );
  }
}