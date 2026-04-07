// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
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
//       title: 'View Status',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const myViewMeasurement(title: 'View Status Page'),
//     );
//   }
// }
//
// class myViewMeasurement extends StatefulWidget {
//   const myViewMeasurement({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<myViewMeasurement> createState() => _myViewMeasurementState();
// }
//
// class _myViewMeasurementState extends State<myViewMeasurement> {
//   _myViewMeasurementState() {
//     viewreply();
//   }
//
//   List<String> id_ = <String>[];
//   List<String> date_ = <String>[];
//   List<String> m1_ = <String>[];
//   List<String> m2_ = <String>[];
//   List<String> m3_ = <String>[];
//   List<String> m4_ = <String>[];
//   List<String> m5_ = <String>[];
//   List<String> m6_ = <String>[];
//   List<String> m7_ = <String>[];
//   List<String> m8_ = <String>[];
//   List<String> m9_ = <String>[];
//   List<String> m10_ = <String>[];
//   List<String> Tsize_ = <String>[];
//   // List<String> tailor_ = <String>[];
//
//   Future<void> viewreply() async {
//     List<String> id = <String>[];
//     List<String> date = <String>[];
//     List<String> m1 = <String>[];
//     List<String> m2 = <String>[];
//     List<String> m3 = <String>[];
//     List<String> m4 = <String>[];
//     List<String> m5 = <String>[];
//     List<String> m6 = <String>[];
//     List<String> m7 = <String>[];
//     List<String> m8 = <String>[];
//     List<String> m9 = <String>[];
//     List<String> m10 = <String>[];
//     List<String> Tsize = <String>[];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/user_view_measurement/';
//
//       var data = await http.post(Uri.parse(url), body: {'lid': lid});
//       var jsondata = json.decode(data.body);
//       String statusMsg = jsondata['status'];
//
//       var arr = jsondata["data"];
//       print(arr.length);
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         date.add(arr[i]['date'].toString());
//         m1.add(arr[i]['m1'].toString());
//         m2.add(arr[i]['m2'].toString());
//         m3.add(arr[i]['m3'].toString());
//         m4.add(arr[i]['m4'].toString());
//         m5.add(arr[i]['m5'].toString());
//         m6.add(arr[i]['m6'].toString());
//         m7.add(arr[i]['m7'].toString());
//         m8.add(arr[i]['m8'].toString());
//         m9.add(arr[i]['m9'].toString());
//         m10.add(arr[i]['m10'].toString());
//         Tsize.add(arr[i]['TS'].toString());
//         // tailor.add(arr[i]['TAILOR'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         date_=date;
//         m1_= m1;
//         m2_ = m2;
//         m3_ = m3;
//         m4_ = m4;
//         m5_ = m5;
//         m6_ = m6;
//         m7_ = m7;
//         m8_ = m8;
//         m9_ = m9;
//         m10_ = m10;
//         Tsize_ = Tsize;
//       });
//
//       print(statusMsg);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: ListView.builder(
//         physics: BouncingScrollPhysics(),
//         itemCount: id_.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//             child: Card(
//               elevation: 6,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Shoulder: ${m1_[index]}",
//                           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//
//                     Text(
//                       "right elbow: ${m2_[index]}",
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: m2_[index] == 'Resolved' ? Colors.green : Colors.red,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "right wrist: \$${m3_[index]}",
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w500,
//                         color: Colors.blueAccent,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "left elbow: ${m4_[index]}",
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "left wrist: ${m5_[index]}",
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black54,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Hip: ${m8_[index]}",
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black54,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Leg Knew: ${m9_[index]}",
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black54,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Leg Ankle: ${m10_[index]}",
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black54,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Top Wear Size: ${Tsize_[index]}",
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black54,
//                       ),
//                     ),
//
//                     const SizedBox(height: 8),
//
//                     Text(
//                       "date: ${date_[index]}",
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: date_[index] == 'Resolved' ? Colors.green : Colors.red,
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measurement Details',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      home: const myViewMeasurement(title: 'Measurement Details'),
    );
  }
}

class myViewMeasurement extends StatefulWidget {
  const myViewMeasurement({super.key, required this.title});

  final String title;

  @override
  State<myViewMeasurement> createState() => _myViewMeasurementState();
}

class _myViewMeasurementState extends State<myViewMeasurement> {
  _myViewMeasurementState() {
    viewreply();
  }

  List<String> id_ = <String>[];
  List<String> date_ = <String>[];
  List<String> m1_ = <String>[];
  List<String> m2_ = <String>[];
  List<String> m3_ = <String>[];
  List<String> m4_ = <String>[];
  List<String> m5_ = <String>[];
  List<String> m6_ = <String>[];
  List<String> m7_ = <String>[];
  List<String> m8_ = <String>[];
  List<String> m9_ = <String>[];
  List<String> m10_ = <String>[];
  List<String> Tsize_ = <String>[];
  List<String> Bsize_ = <String>[];

  Future<void> viewreply() async {
    List<String> id = <String>[];
    List<String> date = <String>[];
    List<String> m1 = <String>[];
    List<String> m2 = <String>[];
    List<String> m3 = <String>[];
    List<String> m4 = <String>[];
    List<String> m5 = <String>[];
    List<String> m6 = <String>[];
    List<String> m7 = <String>[];
    List<String> m8 = <String>[];
    List<String> m9 = <String>[];
    List<String> m10 = <String>[];
    List<String> Tsize = <String>[];
    List<String> Bsize = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/user_view_measurement/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statusMsg = jsondata['status'];

      var arr = jsondata["data"];
      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date'].toString());
        m1.add(arr[i]['m1'].toString());
        m2.add(arr[i]['m2'].toString());
        m3.add(arr[i]['m3'].toString());
        m4.add(arr[i]['m4'].toString());
        m5.add(arr[i]['m5'].toString());
        m6.add(arr[i]['m6'].toString());
        m7.add(arr[i]['m7'].toString());
        m8.add(arr[i]['m8'].toString());
        m9.add(arr[i]['m9'].toString());
        m10.add(arr[i]['m10'].toString());
        Tsize.add(arr[i]['TS'].toString());
        Bsize.add(arr[i]['BS'].toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        m1_ = m1;
        m2_ = m2;
        m3_ = m3;
        m4_ = m4;
        m5_ = m5;
        m6_ = m6;
        m7_ = m7;
        m8_ = m8;
        m9_ = m9;
        m10_ = m10;
        Tsize_ = Tsize;
        Bsize_ = Bsize;
      });

      print(statusMsg);
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Measurement Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: id_.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: id_.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              // Top Wear Card
              MeasurementCard(
                title: 'Top Wear',
                size: Tsize_[index],
                sizeLabel: 'Topwear Size',
                date: date_[index],
                measurements: [
                  MeasurementItem(label: 'Shoulder', value: '${m1_[index]} cm'),
                  MeasurementItem(label: 'Left Elbow', value: '${m4_[index]} cm'),
                  MeasurementItem(label: 'Left Wrist', value: '${m5_[index]} cm'),
                  MeasurementItem(label: 'Right Elbow', value: '${m2_[index]} cm'),
                  MeasurementItem(label: 'Right Wrist', value: '${m3_[index]} cm'),
                ],
              ),
              const SizedBox(height: 20),
              // Bottom Wear Card
              MeasurementCard(
                title: 'Bottom Wear',
                size: Bsize_[index],
                sizeLabel: 'Bottomwear Size',
                date: date_[index],
                measurements: [
                  MeasurementItem(label: 'Hip', value: '${m8_[index]} cm'),
                  MeasurementItem(label: 'Left Knee', value: '${m9_[index]} cm'),
                  MeasurementItem(label: 'Right Knee', value: '${m6_[index]} cm'),
                  MeasurementItem(label: 'Left Ankle', value: '${m10_[index]} cm'),
                  MeasurementItem(label: 'Right Ankle', value: '${m6_[index]} cm'),
                ],
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}

class MeasurementCard extends StatelessWidget {
  final String title;
  final String size;
  final String sizeLabel;
  final String date;
  final List<MeasurementItem> measurements;

  const MeasurementCard({
    super.key,
    required this.title,
    required this.size,
    required this.sizeLabel,
    required this.date,
    required this.measurements,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last updated: $date',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      sizeLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      size,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00D68F),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 20),
            ...measurements.map((item) => Column(
              children: [
                _buildMeasurementRow(item.label, item.value),
                if (measurements.last != item) ...[
                  const SizedBox(height: 20),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 20),
                ],
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class MeasurementItem {
  final String label;
  final String value;

  MeasurementItem({required this.label, required this.value});
}