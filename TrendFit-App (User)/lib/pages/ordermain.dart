
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      home: const Viewodermain(title: 'Flutter Demo Home Page'),
    );
  }
}

class Viewodermain extends StatefulWidget {
  const Viewodermain({super.key, required this.title});

  final String title;

  @override
  State<Viewodermain> createState() => Dress();
}

class Dress extends State<Viewodermain> {
  Dress() {
    viewreply();
  }

  List<String> id_ = <String>[];
  List<String> name_ = <String>[];
  List<String> type_ = <String>[];
  List<String> photo_ = <String>[];
  List<String> price_ = <String>[];
  List<String> qty_ = <String>[];

  Future<void> viewreply() async {
    List<String> id = <String>[];
    List<String> name = <String>[];
    List<String> qty = <String>[];
    List<String> type = <String>[];
    List<String> photo = <String>[];
    List<String> price = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String img = sh.getString('img').toString();
      String oid = sh.getString('oid').toString();
      String url = '$urls/view_cart_user_more/';

      var data = await http.post(Uri.parse(url), body: {
        'oid':oid

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        name.add(arr[i]['dress name'].toString());
        type.add(arr[i]['dress type'].toString());
        photo.add(img + arr[i]['dress photo']);
        price.add(arr[i]['dress price'].toString());
        qty.add(arr[i]['qty'].toString());
      }

      setState(() {
        id_ = id;
        name_ = name;
        type_ = type;
        photo_ = photo;
        price_ = price;
        qty_ = qty;
      });

      print(qty);
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
        title: const Text('More details', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: id_.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Color(0xFFD9EFD5),
            elevation: 10,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      photo_[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Information Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Text(
                          name_[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Type: ${type_[index]}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 5),

                        // Price
                        Text(
                          "Price: \$${price_[index]}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Quantity: ${qty_[index]}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
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
