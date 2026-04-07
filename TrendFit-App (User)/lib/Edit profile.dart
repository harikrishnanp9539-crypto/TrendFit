// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
//
// class Myeditprofile extends StatefulWidget {
//   const Myeditprofile({super.key, required this.title});
//   final String title;
//
//   @override
//   State<Myeditprofile> createState() => _MyeditprofileState();
// }
//
// class _MyeditprofileState extends State<Myeditprofile> {
//   // Controllers
//   TextEditingController Namecontroller = TextEditingController();
//   TextEditingController Placenamecontroller = TextEditingController();
//   TextEditingController Postcontroller = TextEditingController();
//   TextEditingController Pincodecontroller = TextEditingController();
//   TextEditingController Phonecontroller = TextEditingController();
//   TextEditingController Emailcontroller = TextEditingController();
//   TextEditingController Heightcontroller = TextEditingController();
//   TextEditingController Agecontroller = TextEditingController();
//
//   String gender = 'Male';
//
//   String upic = ""; // server base image URL + filename
//
//   // Kerala districts
//   final List<String> keralaDistricts = [
//     'Thiruvananthapuram',
//     'Kollam',
//     'Pathanamthitta',
//     'Alappuzha',
//     'Kottayam',
//     'Idukki',
//     'Ernakulam',
//     'Thrissur',
//     'Palakkad',
//     'Malappuram',
//     'Kozhikode',
//     'Wayanad',
//     'Kannur',
//     'Kasaragod',
//   ];
//
//   // make nullable so we can show hint until server value loaded
//   String selectedDistrict="Thiruvananthapuram";
//
//   File? _selectedImage;
//
//   @override
//   void initState() {
//     super.initState();
//     // call get data here (not in constructor)
//     _get_data();
//   }
//
//   Future<void> _get_data() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//       String imgBase = sh.getString('img') ?? '';
//
//       if (url.isEmpty || lid.isEmpty) {
//         // optional: you can show toast or handle missing prefs
//       }
//
//       final urls = Uri.parse('$url/view_profile_user/');
//       final response = await http.post(urls, body: {'lid': lid}).timeout(const Duration(seconds: 15));
//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//         final status = body['status']?.toString() ?? '';
//         if (status == 'ok') {
//           setState(() {
//             Namecontroller.text = body['username']?.toString() ?? '';
//             gender = body['gender'].toString();
//             selectedDistrict=body['district'].toString();
//             Fluttertoast.showToast(msg: "hhhiiiii"+selectedDistrict.toString());
//             Emailcontroller.text = body['email']?.toString() ?? '';
//             Phonecontroller.text = body['phone']?.toString() ?? '';
//             Placenamecontroller.text = body['place']?.toString() ?? '';
//             Postcontroller.text = body['post']?.toString() ?? '';
//             Pincodecontroller.text = body['pincode']?.toString() ?? '';
//             Agecontroller.text = body['age']?.toString() ?? '';
//             Heightcontroller.text = body['height']?.toString() ?? '';
//
//             // set selectedDistrict only if the server value exists and is in our list
//             final serverDistrict = body['district']?.toString() ?? '';
//
//               selectedDistrict = serverDistrict;
//
//
//             // build upic (base url from prefs 'img' + filename from response)
//             final serverPhoto = body['photo']?.toString() ?? '';
//             upic = (imgBase.isNotEmpty && serverPhoto.isNotEmpty) ? (imgBase + serverPhoto) : '';
//           });
//         } else {
//           Fluttertoast.showToast(msg: 'Profile not found');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network Error: ${response.statusCode}');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
//     }
//   }
//
//   Future<void> _chooseImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     } else {
//       Fluttertoast.showToast(msg: "No image selected");
//     }
//   }
//
//   // Build UI
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurple,
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               // Image display: local selected image has priority, else server upic, else placeholder
//               if (_selectedImage != null) ...[
//                 Image.file(_selectedImage!, height: 150),
//               ] else if (upic.isNotEmpty) ...[
//                 // network image (fits best inside a fixed height)
//                 Image.network(upic, height: 150, errorBuilder: (c, o, s) {
//                   return const Text("Image not available");
//                 }),
//               ] else ...[
//                 const Text("No Image Selected"),
//               ],
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: _chooseImage,
//                 child: const Text("Choose Image"),
//               ),
//
//               _buildTextField('Name', Namecontroller),
//               _buildTextField1('Age', Agecontroller),
//               _buildTextField1('Height', Heightcontroller),
//               _buildTextField('Place', Placenamecontroller),
//               _buildTextField('Post', Postcontroller),
//               _buildTextField1('Pincode', Pincodecontroller),
//               _buildDistrictDropdown(),
//               _buildTextField1('Phone', Phonecontroller, isPhone: true),
//               _buildGenderSelection(),
//
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: senddata,
//                 child: const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   padding: const EdgeInsets.symmetric(vertical: 16.0),
//                   textStyle: const TextStyle(fontSize: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // helpers for text fields
//   Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false, bool isPhone = false, bool isEmail = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isPassword,
//         keyboardType: isPhone ? TextInputType.phone : isEmail ? TextInputType.emailAddress : TextInputType.text,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField1(String label, TextEditingController controller, {bool isPassword = false, bool isPhone = false, bool isEmail = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isPassword,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDistrictDropdown() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: DropdownButtonFormField<String>(
//         value: selectedDistrict,
//         hint: const Text('-- Select District --'),
//         items: keralaDistricts.map((district) {
//           return DropdownMenuItem<String>(
//             value: district,
//             child: Text(district),
//           );
//         }).toList(),
//         onChanged: (value) {
//           setState(() {
//             selectedDistrict = value.toString();
//           });
//         },
//         decoration: InputDecoration(
//           labelText: 'District',
//           border: OutlineInputBorder(),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGenderSelection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 12),
//         Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//         Row(
//           children: [
//             Radio<String>(
//               value: 'Male',
//               groupValue: gender,
//               onChanged: (value) {
//                 setState(() {
//                   gender =  'Male';
//                 });
//               },
//             ),
//             const Text('Male'),
//             Radio<String>(
//               value: 'Female',
//               groupValue: gender,
//               onChanged: (value) {
//                 setState(() {
//                   gender = 'Female';
//                 });
//               },
//             ),
//             const Text('Female'),
//           ],
//         ),
//       ],
//     );
//   }
//
//   // send data (edit)
//   Future<void> senddata() async {
//     String Name = Namecontroller.text;
//     String Place = Placenamecontroller.text;
//     String Post = Postcontroller.text;
//     String Pincode = Pincodecontroller.text;
//     String District = selectedDistrict ?? '';
//     String Phone = Phonecontroller.text;
//     String Gender = gender;
//     String Age = Agecontroller.text;
//     String Height = Heightcontroller.text;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//
//     if (url == 'null' || url.isEmpty) {
//       Fluttertoast.showToast(msg: "Server URL not found.");
//       return;
//     }
//
//     final uri = Uri.parse('$url/edit_profile/');
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['Name'] = Name;
//     request.fields['Place'] = Place;
//     request.fields['Post'] = Post;
//     request.fields['Pincode'] = Pincode;
//     request.fields['District'] = District;
//     request.fields['Phone'] = Phone;
//     request.fields['Gender'] = Gender;
//     request.fields['Age'] = Age;
//     request.fields['height'] = Height;
//     request.fields['lid'] = lid;
//
//     if (_selectedImage != null) {
//       request.files.add(await http.MultipartFile.fromPath('photo', _selectedImage!.path));
//     }
//
//     try {
//       var response = await request.send();
//       var respStr = await response.stream.bytesToString();
//       var data = jsonDecode(respStr);
//
//       if (response.statusCode == 200 && data['status'] == 'ok') {
//         Fluttertoast.showToast(msg: "Submitted successfully.");
//       } else {
//         Fluttertoast.showToast(msg: "Submission failed.");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }
// }
//

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import 'View profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF149B0C),
        useMaterial3: true,
      ),
      home: const Myeditprofile(title: 'Edit Profile'),
    );
  }
}

class Myeditprofile extends StatefulWidget {
  const Myeditprofile({super.key, required this.title});
  final String title;

  @override
  State<Myeditprofile> createState() => _MyeditprofileState();
}

class _MyeditprofileState extends State<Myeditprofile> {
  TextEditingController Namecontroller = TextEditingController();
  TextEditingController Placenamecontroller = TextEditingController();
  TextEditingController Postcontroller = TextEditingController();
  TextEditingController Pincodecontroller = TextEditingController();
  TextEditingController Phonecontroller = TextEditingController();
  TextEditingController Emailcontroller = TextEditingController();
  TextEditingController Heightcontroller = TextEditingController();
  TextEditingController Agecontroller = TextEditingController();

  String gender = 'Male';
  String upic = "";

  final List<String> keralaDistricts = [
    'Thiruvananthapuram',
    'Kollam',
    'Pathanamthitta',
    'Alappuzha',
    'Kottayam',
    'Idukki',
    'Ernakulam',
    'Thrissur',
    'Palakkad',
    'Malappuram',
    'Kozhikode',
    'Wayanad',
    'Kannur',
    'Kasaragod',
  ];

  String selectedDistrict = "Thiruvananthapuram";
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _get_data();
  }

  Future<void> _get_data() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';
      String imgBase = sh.getString('img') ?? '';

      if (url.isEmpty || lid.isEmpty) return;

      final urls = Uri.parse('$url/view_profile_user/');
      final response = await http.post(urls, body: {'lid': lid}).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final status = body['status']?.toString() ?? '';
        if (status == 'ok') {
          setState(() {
            Namecontroller.text = body['username']?.toString() ?? '';
            gender = body['gender']?.toString() ?? 'Male';
            selectedDistrict = body['district']?.toString() ?? selectedDistrict;
            Emailcontroller.text = body['email']?.toString() ?? '';
            Phonecontroller.text = body['phone']?.toString() ?? '';
            Placenamecontroller.text = body['place']?.toString() ?? '';
            Postcontroller.text = body['post']?.toString() ?? '';
            Pincodecontroller.text = body['pincode']?.toString() ?? '';
            Agecontroller.text = body['age']?.toString() ?? '';
            Heightcontroller.text = body['height']?.toString() ?? '';

            final serverPhoto = body['photo']?.toString() ?? '';
            upic = (imgBase.isNotEmpty && serverPhoto.isNotEmpty) ? (imgBase + serverPhoto) : '';
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }

  Future<void> _chooseImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      Fluttertoast.showToast(msg: "No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Stack(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFF0B8E45),
                        width: 4,
                      ),
                    ),
                    child: ClipOval(
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : upic.isNotEmpty
                          ? Image.network(upic, fit: BoxFit.cover, errorBuilder: (c, o, s) {
                        return _buildPlaceholderAvatar();
                      })
                          : _buildPlaceholderAvatar(),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _chooseImage,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B8E45),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Name
              Align(
                alignment: Alignment.centerLeft,
                child: _buildLabel('Name'),
              ),
              _buildTextField(Namecontroller),

              const SizedBox(height: 20),

              // Age & Height row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Age'),
                        _buildTextField(Agecontroller, isNumber: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Height (cm)'),
                        _buildTextField(Heightcontroller, isNumber: true),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Gender
              Align(alignment: Alignment.centerLeft, child: _buildLabel('Gender')),
              const SizedBox(height: 8),
              _buildGenderSelection(),

              const SizedBox(height: 20),
              // Place
              Align(alignment: Alignment.centerLeft, child: _buildLabel('Place')),
              _buildTextField(Placenamecontroller, ),

              const SizedBox(height: 20),

              // Post & Pincode in the same row (labels on left of each field)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Post'),
                        _buildTextField(Postcontroller,),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Pincode'),
                        _buildTextField(Pincodecontroller, isNumber: true),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // District
              Align(alignment: Alignment.centerLeft, child: _buildLabel('District')),
              _buildDistrictDropdown(),

              const SizedBox(height: 20),

              // Phone Number (with left label)
              Align(alignment: Alignment.centerLeft, child: _buildLabel('Phone Number')),
              _buildTextField(Phonecontroller,  isPhone: true),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: senddata,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B8E45),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      color: const Color(0xFFE8F8F0),
      child: const Icon(
        Icons.person,
        size: 80,
        color: Color(0xFF0B8E45),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0B8E45),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller,  {bool isNumber = false, bool isPhone = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isPhone
            ? TextInputType.phone
            : (isNumber ? TextInputType.number : TextInputType.text),
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        ),
      ),
    );
  }

  Widget _buildDistrictDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedDistrict,
        items: keralaDistricts.map((district) {
          return DropdownMenuItem<String>(
            value: district,
            child: Text(district),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedDistrict = value.toString();
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => gender = 'Male'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: gender == 'Male' ? const Color(0xFF0B8E45): Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: gender == 'Male' ? const Color(0xFF0B8E45) : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: gender == 'Male'
                        ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color:Color(0xFF0B8E45),
                        ),
                      ),
                    )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Male',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => gender = 'Female'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: gender == 'Female' ? const Color(0xFF149B0C) : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: gender == 'Female' ? const Color(0xFF149B0C) : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: gender == 'Female'
                        ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0B8E45),
                        ),
                      ),
                    )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Female',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> senddata() async {
    String Name = Namecontroller.text;
    String Place = Placenamecontroller.text;
    String Post = Postcontroller.text;
    String Pincode = Pincodecontroller.text;
    String District = selectedDistrict;
    String Phone = Phonecontroller.text;
    String Gender = gender;
    String Age = Agecontroller.text;
    String Height = Heightcontroller.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    if (url == 'null' || url.isEmpty) {
      Fluttertoast.showToast(msg: "Server URL not found.");
      return;
    }

    final uri = Uri.parse('$url/edit_profile/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['Name'] = Name;
    request.fields['Place'] = Place;
    request.fields['Post'] = Post;
    request.fields['Pincode'] = Pincode;
    request.fields['District'] = District;
    request.fields['Phone'] = Phone;
    request.fields['Gender'] = Gender;
    request.fields['Age'] = Age;
    request.fields['height'] = Height;
    request.fields['lid'] = lid;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', _selectedImage!.path));
    }

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(msg: "Profile updated successfully.");
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  ViewProfilePage(title: 'My Profile'),));
      } else {
        Fluttertoast.showToast(msg: "Update failed.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}
