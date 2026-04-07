//
// import 'dart:io';
//
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trendfitapp/Add%20to%20cart.dart';
// import 'package:trendfitapp/view_recommented_dress.dart';
//
// import 'login.dart';
//
// void main() {
//   runApp(const MyMySignup());
// }
//
// class MyMySignup extends StatelessWidget {
//   const MyMySignup({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MySignup',
//       theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
//       // BackgroundColor: const Color(0xFFF7F9F7),
//       home: const DressFit(title: 'dress recommentation'),
//     );
//   }
// }
//
// class DressFit extends StatefulWidget {
//   const DressFit({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<DressFit> createState() => _DressFitState();
// }
//
// class _DressFitState extends State<DressFit> {
//   File? uploadimage;
//   File? uploadimage2;
//
//   String pic="";
//
//   // _DressFitState(){
//   //   pic="";
//   // }
//
//   final _formKey = GlobalKey<FormState>();
//
//   List<String> id_ = <String>[];
//   List<String> name_ = <String>[];
//   List<String> photo_ = <String>[];
//   List<String> price_ = <String>[];
//   // List<String> size_ = <String>[];
//   List<String> tone_ = <String>[];
//   List<String> category_ = <String>[];
//
//   // existing send_data(), image pickers and permission helpers...
//   void _send_data() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String img = sh.getString('img').toString();
//     String lid = sh.getString('lid').toString();
//
//     final uri = Uri.parse('$url/virtual_try/');
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['lid'] = lid;
//
//     if (_selectedImage != null) {
//       request.files.add(await http.MultipartFile.fromPath('photo', _selectedImage!.path));
//     }
//     if (_selectedImage2 != null) {
//       request.files.add(await http.MultipartFile.fromPath('photo2', _selectedImage2!.path));
//     }
//     try {
//       var response = await request.send();
//       var respStr = await response.stream.bytesToString();
//       var data = jsonDecode(respStr);
//
//       if (response.statusCode == 200 && data['status'] == 'ok') {
//
//         String photo =data['photo'].toString();
//         sh.setString("d_photo", photo);
//
//         setState(() {
//           pic=img+photo;
//         });
//         Fluttertoast.showToast(msg: "Submitted successfully.");
//       } else {
//         Fluttertoast.showToast(msg: "Submission failed.");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }
//
//   File? _selectedImage;
//   String? _encodedImage;
//
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
//   File? _selectedImage2;
//   String? _encodedImage2;
//
//   Future<void> _chooseAndUploadImage2() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage2 = File(pickedImage.path);
//         _encodedImage2 = base64Encode(_selectedImage2!.readAsBytesSync());
//         photo2 = _encodedImage2.toString();
//       });
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage2() async {
//     final PermissionStatus status = await Permission.mediaLibrary.request();
//     if (status.isGranted) {
//       _chooseAndUploadImage2();
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
//   String photo2 = '';
//
//
//   @override
//   Widget build(BuildContext context) {
//     // --- REARRANGED UI ONLY: matches the provided screenshot ---
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Color(0xFFF7F9F7),
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black87),
//             onPressed: () => Navigator.of(context).maybePop(),
//           ),
//           title: const Text(
//             'AI Stylist',
//             style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
//           ),
//           centerTitle: true,
//         ),
//         body: SafeArea(
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 6),
//                       const Text(
//                         'Virtual Try-On',
//                         style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'See how you look. Upload your photo and a\nphoto of a dress.',
//                         style: TextStyle(fontSize: 16, color: Colors.black54),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 24),
//
//                       // --- User Photo Card ---
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(20),
//                         margin: const EdgeInsets.only(bottom: 18),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(color: const Color(0xFFBEE6CF), width: 2),
//                         ),
//                         child: Column(
//                           children: [
//                             // icon
//                             Icon(Icons.person, size: 48, color: const Color(0xFF1A8A3E)),
//                             const SizedBox(height: 12),
//                             const Text('Upload your photo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 8),
//                             const Text('Choose a clear, full-body picture', style: TextStyle(color: Colors.black54)),
//                             const SizedBox(height: 16),
//
//                             // chosen image preview or placeholder
//                             GestureDetector(
//                               onTap: _checkPermissionAndChooseImage,
//                               child: _selectedImage != null
//                                   ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_selectedImage!, height: 200, fit: BoxFit.cover))
//                                   : Container(
//                                 height: 120,
//                                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                                 alignment: Alignment.center,
//                                 child: ElevatedButton(
//                                   onPressed: _checkPermissionAndChooseImage,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFFD6ECD9),
//                                     foregroundColor: const Color(0xFF0F6C31),
//                                     shape: const StadiumBorder(),
//                                     padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
//                                   ),
//                                   child: const Text('Upload Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       // --- Dress Photo Card ---
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(20),
//                         margin: const EdgeInsets.only(bottom: 18),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(color: const Color(0xFFBEE6CF), width: 2),
//                         ),
//                         child: Column(
//                           children: [
//                             Icon(Icons.wallet, size: 48, color: const Color(0xFF1A8A3E)),
//                             const SizedBox(height: 12),
//                             const Text('Upload dress photo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 8),
//                             const Text('Use a photo of the dress on a hanger or flat', style: TextStyle(color: Colors.black54)),
//                             const SizedBox(height: 16),
//
//                             GestureDetector(
//                               onTap: _checkPermissionAndChooseImage2,
//                               child: _selectedImage2 != null
//                                   ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_selectedImage2!, height: 200, fit: BoxFit.cover))
//                                   : Container(
//                                 height: 120,
//                                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                                 alignment: Alignment.center,
//                                 child: ElevatedButton(
//                                   onPressed: _checkPermissionAndChooseImage2,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFFD6ECD9),
//                                     foregroundColor: const Color(0xFF0F6C31),
//                                     shape: const StadiumBorder(),
//                                     padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
//                                   ),
//                                   child: const Text('Upload Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 26),
//
//                       Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           boxShadow: [
//                             BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
//                           ],
//                         ),
//                         padding: const EdgeInsets.only(right: 25,left: 25,top:28,bottom: 15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const Text('Your Virtual Try-On', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 5),
//                             Container(
//                               width: double.infinity,
//                               height: 250,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFF2F2F2),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: pic.isNotEmpty
//                                   ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(pic, fit: BoxFit.cover))
//                                   : const Center(child: Text('Preview will appear here', style: TextStyle(color: Colors.black45))),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 16),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Bottom fixed Generate Try-On button
//               SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: _send_data,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF149B0C),
//                         shape: const StadiumBorder(),
//                       ),
//                       child: const Text('Generate Try-On', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      // BackgroundColor: const Color(0xFFF7F9F7),
      home: const DressFit(title: 'dress recommentation'),
    );
  }
}

class DressFit extends StatefulWidget {
  const DressFit({super.key, required this.title});

  final String title;

  @override
  State<DressFit> createState() => _DressFitState();
}

class _DressFitState extends State<DressFit> {
  File? uploadimage;
  File? uploadimage2;

  String pic = "";

  final _formKey = GlobalKey<FormState>();

  List<String> id_ = <String>[];
  List<String> name_ = <String>[];
  List<String> photo_ = <String>[];
  List<String> price_ = <String>[];
  List<String> tone_ = <String>[];
  List<String> category_ = <String>[];

  // NEW: loading state to show spinner while waiting for server response
  bool _isLoading = false;

  // existing send_data(), image pickers and permission helpers...
  void _send_data() async {
    // If already loading, don't start another request
    if (_isLoading) return;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String img = sh.getString('img').toString();
    String lid = sh.getString('lid').toString();

    // Ensure both images are selected
    if (_selectedImage == null || _selectedImage2 == null) {
      Fluttertoast.showToast(msg: "Please select both images before generating.");
      return;
    }

    setState(() {
      _isLoading = true;
      // clear previous preview while loading (optional)
      pic = "";
    });

    final uri = Uri.parse('$url/virtual_try/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['lid'] = lid;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', _selectedImage!.path));
    }
    if (_selectedImage2 != null) {
      request.files.add(await http.MultipartFile.fromPath('photo2', _selectedImage2!.path));
    }
    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        String photo = data['photo'].toString();
        sh.setString("d_photo", photo);

        setState(() {
          pic = img + photo;
        });
        Fluttertoast.showToast(msg: "Submitted successfully.");
      } else {
        Fluttertoast.showToast(msg: "Submission failed.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      // always reset loading state
      setState(() {
        _isLoading = false;
      });
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

  File? _selectedImage2;
  String? _encodedImage2;

  Future<void> _chooseAndUploadImage2() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage2 = File(pickedImage.path);
        _encodedImage2 = base64Encode(_selectedImage2!.readAsBytesSync());
        photo2 = _encodedImage2.toString();
      });
    }
  }

  Future<void> _checkPermissionAndChooseImage2() async {
    final PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseAndUploadImage2();
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

  String photo2 = '';

  @override
  Widget build(BuildContext context) {
    // --- REARRANGED UI ONLY: matches the provided screenshot ---
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF7F9F7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'AI Stylist',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 6),
                      const Text(
                        'Virtual Try-On',
                        style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'See how you look. Upload your photo and a\nphoto of a dress.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // --- User Photo Card ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFBEE6CF), width: 2),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.person, size: 48, color: const Color(0xFF1A8A3E)),
                            const SizedBox(height: 12),
                            const Text('Upload your photo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text('Choose a clear, full-body picture', style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 16),

                            // chosen image preview or placeholder
                            GestureDetector(
                              onTap: _checkPermissionAndChooseImage,
                              child: _selectedImage != null
                                  ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_selectedImage!, height: 200, fit: BoxFit.cover))
                                  : Container(
                                height: 120,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: _checkPermissionAndChooseImage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD6ECD9),
                                    foregroundColor: const Color(0xFF0F6C31),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                  ),
                                  child: const Text('Upload Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- Dress Photo Card ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFBEE6CF), width: 2),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.wallet, size: 48, color: const Color(0xFF1A8A3E)),
                            const SizedBox(height: 12),
                            const Text('Upload dress photo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text('Use a photo of the dress on a hanger or flat', style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 16),

                            GestureDetector(
                              onTap: _checkPermissionAndChooseImage2,
                              child: _selectedImage2 != null
                                  ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_selectedImage2!, height: 200, fit: BoxFit.cover))
                                  : Container(
                                height: 120,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: _checkPermissionAndChooseImage2,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD6ECD9),
                                    foregroundColor: const Color(0xFF0F6C31),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                  ),
                                  child: const Text('Upload Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        padding: const EdgeInsets.only(right: 25,left: 25,top:28,bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Your Virtual Try-On', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // SHOW LOADING INDICATOR WHEN REQUEST IS IN PROGRESS
                              child: _isLoading
                                  ? const Center(child: CircularProgressIndicator())
                                  : (pic.isNotEmpty
                                  ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(pic, fit: BoxFit.cover))
                                  : const Center(child: Text('Preview will appear here', style: TextStyle(color: Colors.black45)))),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Bottom fixed Generate Try-On button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      // disable button while loading
                      onPressed: _isLoading ? null : _send_data,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading ? Colors.grey : const Color(0xFF149B0C),
                        shape: const StadiumBorder(),
                      ),
                      child: _isLoading
                          ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.0)),
                          SizedBox(width: 12),
                          Text('Generating...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      )
                          : const Text('Generate Try-On', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

