

import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart ';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendfitapp/Add%20to%20cart.dart';
import 'package:trendfitapp/view_recommented_dress.dart';

import 'login.dart';


void main() {
  runApp(const MyMySignup());
}

class MyMySignup extends StatelessWidget {
  const MyMySignup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MySignup',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Recommendation(title: 'dress recommentation'),
    );
  }
}

class Recommendation extends StatefulWidget {
  const Recommendation({super.key, required this.title});

  final String title;

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {


  File? uploadimage;



  final _formKey=GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{ return true; },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_selectedImage != null) ...{
                  InkWell(
                    child:
                    Image.file(_selectedImage!, height: 200,),
                    radius: 399,
                    onTap: _checkPermissionAndChooseImage,
                    // borderRadius: BorderRadius.all(Radius.circular(200)),
                  ),
                } else ...{
                  // Image(image: NetworkImage(),height: 100, width: 70,fit: BoxFit.cover,),
                  InkWell(
                    onTap: _checkPermissionAndChooseImage,
                    child:Column(
                      children: [
                        Image(image: NetworkImage('https://cdn.pixabay.com/photo/2017/11/10/05/24/select-2935439_1280.png'),height: 200,width: 200,),
                        Text('Select Image',style: TextStyle(color: Colors.cyan))
                      ],
                    ),
                  ),
                },

                ElevatedButton(
                  onPressed: () {

                    _send_data();


                  },
                  child: Text("Recommend"),
                ),

                Container(
                  height:200,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),

                    itemCount: id_.length,
                    itemBuilder: (BuildContext context, int index) {
                      return
                        ListTile(
                          onLongPress: () {
                            print("long press" + index.toString());
                          },
                          title: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Card(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // CircleAvatar(radius: 50,backgroundImage: NetworkImage(photo_[index])),
                                          Column(
                                            children: [
                                              Image(image:NetworkImage(photo_[index]),height: 200,width: 150,),
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(name_[index]),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text("Price  :  "+price_[index]),
                                              ),
                                              // Padding(
                                              //   padding: EdgeInsets.all(5),
                                              //   child: Text("Size  :  "+size_[index]),
                                              // ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  final pref = await SharedPreferences.getInstance();
                                                  pref.setString("did", id_[index]);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => MyAddtocartpage(title: '')),
                                                  );
                                                },
                                                child: Text("Add to cart"),
                                              ),
                                            ],
                                          ),
                                        ]
                                    ),
                                    elevation: 8,
                                    margin: EdgeInsets.all(10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );

                    },
                  ),
                )




              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> id_ = <String>[];
  List<String> name_ = <String>[];
  List<String> photo_ = <String>[];
  List<String> price_ = <String>[];
  // List<String> size_ = <String>[];
  List<String> tone_ = <String>[];
  List<String> category_ = <String>[];


  void _send_data() async{

    List<String> id = <String>[];
    List<String> name = <String>[];
    List<String> photoa = <String>[];
    List<String> price = <String>[];
    // List<String> size = <String>[];
    List<String> tone = <String>[];
    List<String> category = <String>[];






    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/recommendations/');
    try {

      final response = await http.post(urls, body: {
        "Photo":photo,
        "lid":lid,






      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];

        // Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewRec_dress(title: '')));
        var arr = jsonDecode(response.body)["data"];
        print(arr.length);

        for (int i = 0; i < arr.length; i++) {
          id.add(arr[i]['id'].toString());
          name.add(arr[i]['Dress name'].toString());
          price.add(arr[i]['Price'].toString());
          // size.add(arr[i]['Size'].toString());
          tone.add(arr[i]['Tone'].toString());
          category.add(arr[i]['Category'].toString());
          photoa.add(sh.getString("img").toString()+ arr[i]['Photo'].toString());

        }

        setState(() {
          id_ = id;
          name_=name;
          price_=price;
          // size_=size;
          tone_=tone;
          category_=category;
          photo_=photoa;

        });




      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e){
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  File? _selectedImage;
  String? _encodedImage;
  Future<void> _chooseAndUploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
        photo = _encodedImage.toString();
      });
    }
  }

  Future<void> _checkPermissionAndChooseImage() async {
    final PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseAndUploadImage();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
            'Please go to app settings and grant permission to choose an image.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String photo = '';




}
