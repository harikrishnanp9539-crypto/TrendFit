// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trendfitapp/login.dart';
// import 'package:image_picker/image_picker.dart';
//
// class Mysignuppage extends StatefulWidget {
//   const Mysignuppage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<Mysignuppage> createState() => _MysignuppageState();
// }
//
// class _MysignuppageState extends State<Mysignuppage> {
//   TextEditingController Namecontroller = TextEditingController();
//   TextEditingController Placenamecontroller = TextEditingController();
//   TextEditingController Postcontroller = TextEditingController();
//   TextEditingController Pincodecontroller = TextEditingController();
//   // removed Districtcontroller in favour of dropdown selection
//   TextEditingController Phonecontroller = TextEditingController();
//   TextEditingController Emailcontroller = TextEditingController();
//   TextEditingController Gendercontroller = TextEditingController();
//   TextEditingController Heightcontroller = TextEditingController();
//   TextEditingController Passwordcontroller = TextEditingController();
//   TextEditingController Confirmpasswordcontroller = TextEditingController();
//   TextEditingController Agecontroller = TextEditingController();
//   String gender = 'Male';
//
//   // Kerala districts list
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
//   // selected district state
//   late String selectedDistrict;
//
//   @override
//   void initState() {
//     super.initState();
//     // default to first district
//     selectedDistrict = keralaDistricts[0];
//   }
//
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
//               _selectedImage != null
//                   ? Image.file(_selectedImage!, height: 150)
//                   : const Text("No Image Selected"),
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
//               _buildDistrictDropdown(), // <-- dropdown here
//               _buildTextField1('Phone', Phonecontroller, isPhone: true),
//               _buildTextField('Email', Emailcontroller, isEmail: true),
//               _buildGenderSelection(),
//               _buildTextField('Password', Passwordcontroller, isPassword: true),
//               _buildTextField('Confirm Password', Confirmpasswordcontroller, isPassword: true),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: senddata,
//                 child: const Text ("Submit",   style: TextStyle(fontSize: 18 ,color: Colors.white),),
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
//   // Helper method to build the text fields
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
//   // District dropdown widget
//   Widget _buildDistrictDropdown() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: DropdownButtonFormField<String>(
//         value: selectedDistrict,
//         items: keralaDistricts.map((district) {
//           return DropdownMenuItem<String>(
//             value: district,
//             child: Text(district),
//           );
//         }).toList(),
//         onChanged: (value) {
//           if (value != null) {
//             setState(() {
//               selectedDistrict = value;
//             });
//           }
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
//   // Gender selection using radio buttons
//   Widget _buildGenderSelection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 12),
//         Text(
//           'Gender',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Radio<String>(
//               value: 'Male',
//               groupValue: gender,
//               onChanged: (value) {
//                 setState(() {
//                   gender = value!;
//                 });
//               },
//             ),
//             const Text('Male'),
//             Radio<String>(
//               value: 'Female',
//               groupValue: gender,
//               onChanged: (value) {
//                 setState(() {
//                   gender = value!;
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
//   // Date Picker for DOB
//   File? _selectedImage;
//   Future<void> _chooseImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//     else {
//       Fluttertoast.showToast(msg: "No image selected");
//     }
//   }
//
//   // Send data to the server
//   Future<void> senddata() async {
//     String Name = Namecontroller.text;
//     String Place = Placenamecontroller.text;
//     String Post = Postcontroller.text;
//     String Pincode = Pincodecontroller.text;
//     String District = selectedDistrict; // use selected district
//     String Phone = Phonecontroller.text;
//     String Email = Emailcontroller.text;
//     String Gender = gender;
//     String Age = Agecontroller.text;
//     String Height = Heightcontroller.text;
//     String Password = Passwordcontroller.text;
//     String Confirmpassword = Confirmpasswordcontroller.text;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//
//     if (url == 'null' || url.isEmpty) {
//       Fluttertoast.showToast(msg: "Server URL not found.");
//       return;
//     }
//
//     final uri = Uri.parse('$url/user_flutt/');
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['Name'] = Name;
//     request.fields['Place'] = Place;
//     request.fields['Post'] = Post;
//     request.fields['Pincode'] = Pincode;
//     request.fields['District'] = District;
//     request.fields['Phone'] = Phone;
//     request.fields['Email'] = Email;
//     request.fields['Gender'] = Gender;
//     request.fields['Age'] = Age;
//     request.fields['height'] = Height;
//     request.fields['Password'] = Password;
//     request.fields['Confirmpassword'] = Confirmpassword;
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
//
//
//

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendfitapp/login.dart';
import 'package:image_picker/image_picker.dart';

class Mysignuppage extends StatefulWidget {
  const Mysignuppage({super.key, required this.title});
  final String title;

  @override
  State<Mysignuppage> createState() => _MysignuppageState();
}

class _MysignuppageState extends State<Mysignuppage> {
  TextEditingController Namecontroller = TextEditingController();
  TextEditingController Placenamecontroller = TextEditingController();
  TextEditingController Postcontroller = TextEditingController();
  TextEditingController Pincodecontroller = TextEditingController();
  // removed Districtcontroller in favour of dropdown selection
  TextEditingController Phonecontroller = TextEditingController();
  TextEditingController Emailcontroller = TextEditingController();
  TextEditingController Gendercontroller = TextEditingController();
  TextEditingController Heightcontroller = TextEditingController();
  TextEditingController Passwordcontroller = TextEditingController();
  TextEditingController Confirmpasswordcontroller = TextEditingController();
  TextEditingController Agecontroller = TextEditingController();
  String gender = 'Male';

  // Kerala districts list
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

  // selected district state
  late String selectedDistrict;

  @override
  void initState() {
    super.initState();
    // default to first district
    selectedDistrict = keralaDistricts[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Create Account",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// PROFILE IMAGE
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.green.shade100,
                  backgroundImage:
                  _selectedImage != null ? FileImage(_selectedImage!) : null,
                  child: _selectedImage == null
                      ? const Icon(Icons.person, size: 60, color: Colors.green)
                      : null,
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    onPressed: _chooseImage,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),

            _field("Name", Namecontroller),
            _field("Email", Emailcontroller, type: TextInputType.emailAddress),
            _field("Phone Number", Phonecontroller, type: TextInputType.phone),

            /// AGE & HEIGHT
            Row(
              children: [
                Expanded(child: _field("Age", Agecontroller, type: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: _field("Height (cm)", Heightcontroller, type: TextInputType.number)),
              ],
            ),

            /// GENDER
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Gender", style: TextStyle(color: Colors.green.shade700)),
            ),
            Row(
              children: [
                Radio(value: "Male", groupValue: gender, onChanged: (v) => setState(() => gender = v!)),
                const Text("Male"),
                Radio(value: "Female", groupValue: gender, onChanged: (v) => setState(() => gender = v!)),
                const Text("Female"),
              ],
            ),

            /// DISTRICT
            Row(
              children: [
                // const SizedBox(width: 8),
                Expanded(child: _buildDistrictDropdown()),
              ],
            ),

            /// PLACE
            Row(
              children: [
                // const SizedBox(width: 8),
                Expanded(child: _field("Place", Placenamecontroller)),
              ],
            ),

            ///  PIN & POST
            Row(
              children: [
                Expanded(child: _field("Pincode", Pincodecontroller, type: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: _field("Post", Postcontroller)),
              ],
            ),
            _field("Password", Passwordcontroller, isPassword: true),
            _field("Confirm Password", Confirmpasswordcontroller, isPassword: true),

            const SizedBox(height: 24),

            /// SIGN UP BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: senddata,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Sign Up", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController controller, {
        TextInputType type = TextInputType.text,
        bool isPassword = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }


  // Helper method to build the text fields
  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false, bool isPhone = false, bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isPhone ? TextInputType.phone : isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }

  Widget _buildTextField1(String label, TextEditingController controller, {bool isPassword = false, bool isPhone = false, bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }

  // District dropdown widget
  Widget _buildDistrictDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedDistrict,
        items: keralaDistricts.map((district) {
          return DropdownMenuItem<String>(
            value: district,
            child: Text(district),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedDistrict = value;
            });
          }
        },
        decoration: InputDecoration(
          labelText: 'District',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }

  // Gender selection using radio buttons
  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          'Gender',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Radio<String>(
              value: 'Male',
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
            const Text('Male'),
            Radio<String>(
              value: 'Female',
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
            const Text('Female'),
          ],
        ),
      ],
    );
  }

  // Date Picker for DOB
  File? _selectedImage;
  Future<void> _chooseImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
    else {
      Fluttertoast.showToast(msg: "No image selected");
    }
  }

  // Send data to the server
  Future<void> senddata() async {
    String Name = Namecontroller.text;
    String Place = Placenamecontroller.text;
    String Post = Postcontroller.text;
    String Pincode = Pincodecontroller.text;
    String District = selectedDistrict; // use selected district
    String Phone = Phonecontroller.text;
    String Email = Emailcontroller.text;
    String Gender = gender;
    String Age = Agecontroller.text;
    String Height = Heightcontroller.text;
    String Password = Passwordcontroller.text;
    String Confirmpassword = Confirmpasswordcontroller.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    if (url == 'null' || url.isEmpty) {
      Fluttertoast.showToast(msg: "Server URL not found.");
      return;
    }

    final uri = Uri.parse('$url/user_flutt/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['Name'] = Name;
    request.fields['Place'] = Place;
    request.fields['Post'] = Post;
    request.fields['Pincode'] = Pincode;
    request.fields['District'] = District;
    request.fields['Phone'] = Phone;
    request.fields['Email'] = Email;
    request.fields['Gender'] = Gender;
    request.fields['Age'] = Age;
    request.fields['height'] = Height;
    request.fields['Password'] = Password;
    request.fields['Confirmpassword'] = Confirmpassword;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', _selectedImage!.path));
    }

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(msg: "Submitted successfully.");
        Navigator.push(context, MaterialPageRoute(builder: (context) => Myloginpage(title: '',),));
      } else {
        Fluttertoast.showToast(msg: "Submission failed.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}




