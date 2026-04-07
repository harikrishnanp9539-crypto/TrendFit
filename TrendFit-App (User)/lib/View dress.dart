
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Add to cart.dart'; // Assuming this is the page where the cart functionality is handled

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
      home: const MyViewdresspage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyViewdresspage extends StatefulWidget {
  const MyViewdresspage({super.key, required this.title});

  final String title;

  @override
  State<MyViewdresspage> createState() => Dress();
}

class Dress extends State<MyViewdresspage> {
  Dress() {
    viewreply();
  }

  List<String> id_ = <String>[];
  List<String> name_ = <String>[];
  List<String> size_ = <String>[];
  List<String> type_ = <String>[];
  List<String> photo_ = <String>[];
  List<String> price_ = <String>[];

  Future<void> viewreply() async {
    List<String> id = <String>[];
    List<String> name = <String>[];
    List<String> size = <String>[];
    List<String> type = <String>[];
    List<String> photo = <String>[];
    List<String> price = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String img = sh.getString('img').toString();
      String url = '$urls/view_dress_user/';

      var data = await http.post(Uri.parse(url), body: {});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        name.add(arr[i]['name'].toString());
        size.add(arr[i]['size'].toString());
        type.add(arr[i]['type'].toString());
        photo.add(img + arr[i]['photo']);
        price.add(arr[i]['price'].toString());
      }

      setState(() {
        id_ = id;
        name_ = name;
        size_ = size;
        type_ = type;
        photo_ = photo;
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: id_.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
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

                        // Size and Type
                        Text(
                          "Size: ${size_[index]}",
                          style: const TextStyle(fontSize: 14),
                        ),
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
                        const SizedBox(height: 10),

                        // Add to Cart Button
                        ElevatedButton(
                          onPressed: () async {
                            SharedPreferences sh =
                            await SharedPreferences.getInstance();
                            await sh.setString('DRESS', id_[index].toString());

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MyAddtocartpage(title: "Cart"),
                              ),
                            );
                          },
                          child: const Text("Remove the Dress"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // primary: Theme.of(context).primaryColor,
                          ),
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
