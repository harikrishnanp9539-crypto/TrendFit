// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trendfitapp/pages/settingsscreen.dart';
// import 'Home.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Submit Review',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const Mysendreviewpage(title: 'Submit Review'),
//     );
//   }
// }
//
// class Mysendreviewpage extends StatefulWidget {
//   const Mysendreviewpage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<Mysendreviewpage> createState() => _MysendreviewpageState();
// }
//
// class _MysendreviewpageState extends State<Mysendreviewpage> {
//   // Controllers for review and rating input fields
//   TextEditingController reviewController = TextEditingController();
//   TextEditingController ratingController = TextEditingController();
//
//   bool _isSubmitting = false;  // Flag for showing loading indicator
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               // Review Text Field
//               TextFormField(
//                 controller: reviewController,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   labelText: 'Review',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 ),
//                 keyboardType: TextInputType.multiline,
//               ),
//               const SizedBox(height: 20),
//
//               // Rating Text Field
//               TextFormField(
//                 controller: ratingController,
//                 decoration: InputDecoration(
//                   labelText: 'Rating (1 to 5)',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 20),
//
//               // Submit Button
//               ElevatedButton(
//                 onPressed: _isSubmitting
//                     ? null  // Disable button while submitting
//                     : () {
//                   setState(() {
//                     _isSubmitting = true;  // Show loading indicator
//                   });
//                   senddata();
//                 },
//                 child: _isSubmitting
//                     ? CircularProgressIndicator(color: Colors.white)  // Show loader
//                     : const Text("Submit Review",style: TextStyle(color: Colors.white),),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple, // Button color
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
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
//   // Function to send the review data to the server
//   Future<void> senddata() async {
//     String review = reviewController.text;
//     String rating = ratingController.text;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//
//     final urls = Uri.parse('$url/send_review/');
//     try {
//       final response = await http.post(urls, body: {
//         'review': review,
//         'rating': rating,
//         'lid': lid,
//       });
//
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status == 'ok') {
//           Fluttertoast.showToast(msg: 'Review submitted successfully! \n Thank you For your feedback');
//           // Navigator.pushReplacement(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => SettingsPage()),
//           // );
//         } else {
//           Fluttertoast.showToast(msg: 'Failed to submit review.');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     } finally {
//       setState(() {
//         _isSubmitting = false;  // Hide loading indicator after submission
//       });
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:trendfitapp/pages/settingsscreen.dart';
import 'Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Submit Review',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Mysendreviewpage(title: 'Submit Review'),
    );
  }
}

class Mysendreviewpage extends StatefulWidget {
  const Mysendreviewpage({super.key, required this.title});

  final String title;

  @override
  State<Mysendreviewpage> createState() => _MysendreviewpageState();
}

class _MysendreviewpageState extends State<Mysendreviewpage> {
  TextEditingController reviewController = TextEditingController();

  int selectedRating = 2;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.of(context).maybePop()),
        title: const Text('Review', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InputDecorator(
                decoration: InputDecoration(
                  labelText: "Rating (1 to 5)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
                child: RatingBar.builder(
                  initialRating: selectedRating.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 35,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      selectedRating = rating.toInt();
                    });
                  },
                ),
              ),
              // Review Text Field

              const SizedBox(height: 20),
              TextFormField(
                controller: reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Review',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                  setState(() {
                    _isSubmitting = true;
                  });
                  senddata();
                },
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Submit Review",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Send Data Function
  Future<void> senddata() async {
    String review = reviewController.text;
    String rating = selectedRating.toString();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/send_review/');
    try {
      final response = await http.post(urls, body: {
        'review': review,
        'rating': rating,
        'lid': lid,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(
              msg: 'Review submitted successfully!\nThank you for your feedback');
        } else {
          Fluttertoast.showToast(msg: 'Failed to submit review.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
