
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:trendfitapp/pages/ordermain.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Viewodersub(title: 'Flutter Demo Home Page'),
    );
  }
}

class Viewodersub extends StatefulWidget {
  const Viewodersub({super.key, required this.title});

  final String title;

  @override
  State<Viewodersub> createState() => Dress();
}

class Dress extends State<Viewodersub> {
  Dress() {
    viewreply();
  }

  List<String> id_ = <String>[];
  List<String> date_ = <String>[];
  List<String> price_ = <String>[];

  Future<void> viewreply() async {
    List<String> id = <String>[];
    List<String> date = <String>[];
    List<String> price = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/view_order_user/';

      var data = await http.post(Uri.parse(url), body: {
        'lid':lid
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date'].toString());
        price.add(arr[i]['amount'].toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        price_ = price;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.of(context).maybePop()),
        title: const Text('Orders', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: id_.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Color(0xFFC0EAB7),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Information Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),

                        // Size and Type
                        Text(
                          "date: ${date_[index]}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Amount: \$${price_[index]}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 5),

                        // Add to Cart Button
                        Row(
                          children: [
                            const SizedBox(width: 115,),
                            ElevatedButton(
                              onPressed: () async {
                                SharedPreferences sh = await SharedPreferences.getInstance();
                                sh.setString('oid',id_[index].toString());
                                Navigator.push(context, MaterialPageRoute(builder:(context) => Viewodermain(title: ''),));
                              },
                              child: const Text("View More"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white
                                // primary: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
