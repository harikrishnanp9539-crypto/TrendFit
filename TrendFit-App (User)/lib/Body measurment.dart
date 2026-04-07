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
// import 'package:trendfitapp/view%20body%20measurement.dart';
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
//       home: const MyBodymeasurementpage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyBodymeasurementpage extends StatefulWidget {
//   const MyBodymeasurementpage({super.key, required this.title});
//
//
//
//   final String title;
//
//   @override
//   State<MyBodymeasurementpage> createState() => _MyBodymeasurementpageState();
// }
//
// class _MyBodymeasurementpageState extends State<MyBodymeasurementpage> {
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
//
//             _selectedImage != null
//                 ? Image.file(_selectedImage!, height: 150)
//                 : const Text("No Image "),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _chooseImage,
//               child: const Text("Choose Image"),
//             ),
//
//
//
//
//             SizedBox(height: 10,),
//
//             // RadioListTile(value: "Top", groupValue: Type, onChanged: (value) { setState(() {Type="Top";}); },title: Text("Top"),),
//             // RadioListTile(value: "Bottom", groupValue: Type, onChanged: (value) { setState(() {Type="Bottom";}); },title: Text("Bottom"),),
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
//
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
//
//     final uri = Uri.parse('$url/poseestimation/');
//     var request = http.MultipartRequest('POST', uri);
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
//     // try {
//     //   final response = await http.post(urls, body: {
//     //     'text':Dressname,
//     //     // 'type':Type,
//     //     'image':photos,
//     //     'lid':lid,
//     //
//     //
//     //
//     //   });
//     //   if (response.statusCode == 200) {
//     //     String status = jsonDecode(response.body)['status'];
//     //     if (status=='ok') {
//     //
//     //       Navigator.push(context, MaterialPageRoute(
//     //         builder: (context) => myViewMeasurement(title: "Home"),));
//     //     }else {
//     //       Fluttertoast.showToast(msg: 'Not Found');
//     //     }
//     //   }
//     //   else {
//     //     Fluttertoast.showToast(msg: 'Network Error');
//     //   }
//     // }
//     // catch (e){
//     //   Fluttertoast.showToast(msg: e.toString());
//     // }
//
//
//   }
//
//   String photo = '';
//
// }
//


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:trendfitapp/view%20body%20measurement.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AiBodyMeasurementScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AiBodyMeasurementScreen extends StatefulWidget {
  const AiBodyMeasurementScreen({super.key});

  @override
  State<AiBodyMeasurementScreen> createState() =>
      _AiBodyMeasurementScreenState();
}

class _AiBodyMeasurementScreenState extends State<AiBodyMeasurementScreen> {
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final pickedFile =
      await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error picking image: $e');
    }
  }

  Future<void> _submitForm() async {
    if (selectedImage == null) {
      Fluttertoast.showToast(msg: 'Please select an image first.');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String url = prefs.getString('url') ?? 'http://your-server.com';
      String lid = prefs.getString('lid') ?? '';

      if (url.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: 'Missing url or lid in SharedPreferences');
        setState(() {
          _isUploading = false;
        });
        return;
      }

      var uri = Uri.parse('$url/poseestimation/');
      var request = http.MultipartRequest('POST', uri);
      request.fields['lid'] = lid;

      // add file
      request.files
          .add(await http.MultipartFile.fromPath('photo', selectedImage!.path));

      var streamedResponse = await request.send();
      var responseString = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        var data = jsonDecode(responseString);
        if (data['status'] == 'ok') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => myViewMeasurement(title: ''),));
          Fluttertoast.showToast(msg: 'Photo uploaded');
          _clearForm();
        } else {
          Fluttertoast.showToast(
              msg: 'Upload failed: ${data['message'] ?? 'Server error'}');
        }
      } else {
        Fluttertoast.showToast(
            msg:
            'Upload failed with status: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _clearForm() {
    setState(() {
      selectedImage = null;
    });
  }

  // dashed rounded border painter
  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width - 40;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: const Text(
          'AI Body Measurement',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Title + subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Column(
                children: const [
                  Text(
                    'Measure your \n Body measurements',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      height: 1.05,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Find the your body measurements  that helps you to find your correct outfit size .',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Large dashed upload area
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CustomPaint(
                          painter: DashedRectPainter(
                            strokeWidth: 2,
                            color: Colors.grey.shade400,
                            radius: 14,
                            gap: 8,
                            dashWidth: 6,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 260,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 24),
                            child: Center(
                              child: selectedImage != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                                  : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.image_outlined,
                                      size: 56,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    'Your uploaded image will appear here',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // optional clear button below the area (hidden unless image selected)
                    if (selectedImage != null) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _clearForm,
                        child: const Text('Remove image',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Bottom large upload button
            SafeArea(
              top: false,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14),
                child: SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton.icon(
                    onPressed: _isUploading ? null : _submitForm,
                    icon: const Icon(Icons.file_upload_outlined, size: 22),
                    label: _isUploading
                        ? const Text('Uploading...')
                        : const Text(
                      'Upload Image',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22D583), // bright green
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      elevation: 4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for a dashed rounded rectangle border
class DashedRectPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double radius;
  final double gap;
  final double dashWidth;

  DashedRectPainter({
    this.strokeWidth = 2,
    this.color = Colors.grey,
    this.radius = 12,
    this.gap = 6,
    this.dashWidth = 6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius));
    final path = Path()..addRRect(rrect);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Convert path to metrics and draw dashed effect along its length
    final metrics = path.computeMetrics().toList();
    for (var metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final currentDash = dashWidth;
        final end = distance + currentDash;
        final extract = metric.extractPath(distance, end.clamp(0, metric.length));
        canvas.drawPath(extract, paint);
        distance = end + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.gap != gap ||
        oldDelegate.dashWidth != dashWidth;
  }
}
