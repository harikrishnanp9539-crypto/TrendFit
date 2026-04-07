//
//
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
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
//       home: const MyAddmydressPage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyAddmydressPage extends StatefulWidget {
//   const MyAddmydressPage({super.key, required this.title});
//
//
//
//   final String title;
//
//   @override
//   State<MyAddmydressPage> createState() => _MyAddmydressPageState();
// }
//
// class _MyAddmydressPageState extends State<MyAddmydressPage> {
//
//   File? uploadimage;
//   TextEditingController Namecontroller=new TextEditingController();
//   TextEditingController typecontroller=new TextEditingController();
//
//   String Type="Top";
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
//       body: SingleChildScrollView(
//
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (_selectedImage != null) ...{
//               InkWell(
//                 child:
//                 Image.file(_selectedImage!, height: 400,),
//                 radius: 399,
//                 onTap: _checkPermissionAndChooseImage,
//                 // borderRadius: BorderRadius.all(Radius.circular(200)),
//               ),
//             } else ...{
//               // Image(image: NetworkImage(),height: 100, width: 70,fit: BoxFit.cover,),
//               InkWell(
//                 onTap: _checkPermissionAndChooseImage,
//                 child:Column(
//                   children: [
//                     Image(image: NetworkImage('https://cdn.pixabay.com/photo/2017/11/10/05/24/select-2935439_1280.png'),height: 200,width: 200,),
//                     Text('Select Image',style: TextStyle(color: Colors.cyan))
//                   ],
//                 ),
//               ),
//             },
//
//
//             TextFormField(
//               controller: Namecontroller,
//               decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Enter Dress name')),),
//             SizedBox(height: 10,),
//
//             RadioListTile(value: "Top", groupValue: Type, onChanged: (value) { setState(() {Type="Top";}); },title: Text("Top"),),
//             RadioListTile(value: "Bottom", groupValue: Type, onChanged: (value) { setState(() {Type="Bottom";}); },title: Text("Bottom"),),
//
//
//
//             // TextFormField(
//             //   controller: typecontroller,
//             //   decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Enter Dress Type')),),
//             SizedBox(height: 10,),
//
//             ElevatedButton(onPressed: (){
//               senddata();
//             }, child: Text("Submit"))
//
//
//           ],
//         ),
//       ),
//
//
//
//     );
//   }
//   Future<void> senddata() async {
//     String Dressname=Namecontroller.text;
//     // String Type=typecontroller.text;
//     String photos=photo;
//
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//
//     final urls = Uri.parse('$url/add_my_dress_user/');
//     try {
//       final response = await http.post(urls, body: {
//         'name':Dressname,
//         'type':Type,
//         'photo':photos,
//         'lid':lid,
//
//
//
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status=='ok') {
//
//           Navigator.push(context, MaterialPageRoute(
//             builder: (context) => MyHomePage(title: "Home"),));
//         }else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       }
//       else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     }
//     catch (e){
//       Fluttertoast.showToast(msg: e.toString());
//     }
//
//
//   }
//   File? _selectedImage;
//   String? _encodedImage;
//   Future<void> _chooseAndUploadImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//         _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
//         photo = _encodedImage.toString();
//       });
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage() async {
//     final PermissionStatus status = await Permission.mediaLibrary.request();
//     if (status.isGranted) {
//       _chooseAndUploadImage();
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: const Text('Permission Denied'),
//           content: const Text(
//             'Please go to app settings and grant permission to choose an image.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   String photo = '';
//
// }
//



// FULLY RUNNABLE FLUTTER CODE (Android Studio Compatible)

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyDressApp());
}

class MyDressApp extends StatelessWidget {
  const MyDressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Upload Dress",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF9F9),
      ),
      home: const AddMyDressPage(),
    );
  }
}

class AddMyDressPage extends StatefulWidget {
  const AddMyDressPage({super.key});

  @override
  State<AddMyDressPage> createState() => _AddMyDressPageState();
}

class _AddMyDressPageState extends State<AddMyDressPage> {
  File? _selectedImage;
  String encodedImage = "";
  final picker = ImagePicker();
  final nameController = TextEditingController();
  String selectedType = "Top Wear";
  bool uploading = false;

  Future<void> pickImage() async {

    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      File img = File(picked.path);
      List<int> bytes = await img.readAsBytes();
      setState(() {
        _selectedImage = img;
        encodedImage = base64Encode(bytes);
      });
    }
  }

  Future<void> uploadDress() async {
    if (encodedImage.isEmpty) {
      Fluttertoast.showToast(msg: "Upload an image");
      return;
    }
    if (nameController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Enter a dress name");
      return;
    }

    setState(() => uploading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = prefs.getString("url") ?? "";   // Your API Base URL
    String lid = prefs.getString("lid") ?? "1";  // Fake fallback ID

    final uri = Uri.parse("$url/add_my_dress_user/");

    try {
      final response = await http.post(uri, body: {
        "name": nameController.text.trim(),
        "type": selectedType.contains("Top") ? "Top" : "Bottom",
        "photo": encodedImage,
        "lid": lid,
      });

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData["status"] == "ok") {
        Fluttertoast.showToast(msg: "Upload Successful!");
      } else {
        Fluttertoast.showToast(msg: "Upload Failed");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }

    setState(() => uploading = false);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("AI Stylist",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                fontSize: 22)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Title
            const Text(
              "Upload Your Dress",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Add your own clothing items to get personalized recommendations.",
                style: TextStyle(fontSize: 15, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // Dotted Image Picker Box
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: w - 40,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFF9ACFB0),
                      width: 2,
                      style: BorderStyle.solid),
                ),
                child: _selectedImage == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image_outlined,
                        size: 55, color: Color(0xFF1B7A3A)),
                    SizedBox(height: 12),
                    Text("Tap to upload your dress",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    Text("Select Image",
                        style: TextStyle(
                            fontSize: 15, color: Color(0xFF1B7A3A))),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_selectedImage!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Dress Name Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text("Dress Name"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Item Type Selector
            const Text("Select item type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

            Row(
              children: [
                buildTypeCard("Top Wear", Icons.checkroom),
                buildTypeCard("Bottom Wear", Icons.shopping_bag),
              ],
            ),

            const SizedBox(height: 30),

            // Upload Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SizedBox(
                width: w,
                height: 60,
                child: ElevatedButton(
                  onPressed: uploading ? null : uploadDress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B7A3A),
                    shape: const StadiumBorder(),
                  ),
                  child: uploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Upload Dress Image",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // UI for Top Wear & Bottom Wear Cards
  Widget buildTypeCard(String label, IconData icon) {
    bool active = selectedType == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedType = label),
        child: Container(
          height: 110,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: active ? const Color(0xFFE4F6EA) : Colors.white,
            border: Border.all(
              color: active ? const Color(0xFF1B7A3A) : Colors.grey,
              width: active ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 28,
                  color: active ? const Color(0xFF1B7A3A) : Colors.black54),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: active
                          ? const Color(0xFF1B7A3A)
                          : Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}
