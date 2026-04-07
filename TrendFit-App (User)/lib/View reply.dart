// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trendfitapp/Home.dart';
// import 'Send complaint.dart';
//
// void main() {
//   runApp(const ViewReply());
// }
//
// class ViewReply extends StatelessWidget {
//   const ViewReply({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'View Reply',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
//         useMaterial3: true,
//       ),
//       home: const ViewReplyPage(title: 'View Reply'),
//     );
//   }
// }
//
// class ViewReplyPage extends StatefulWidget {
//   const ViewReplyPage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<ViewReplyPage> createState() => _ViewReplyPageState();
// }
//
// class _ViewReplyPageState extends State<ViewReplyPage> {
//
//   _ViewReplyPageState(){
//     viewReply();
//   }
//
//   List<String> id_ = <String>[];
//   List<String> date_ = <String>[];
//   List<String> complaint_ = <String>[];
//   List<String> reply_ = <String>[];
//   List<String> status_ = <String>[];
//
//   Future<void> viewReply() async {
//     List<String> id = <String>[];
//     List<String> date = <String>[];
//     List<String> complaint = <String>[];
//     List<String> reply = <String>[];
//     List<String> status = <String>[];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/view_reply_user/';
//
//       var data = await http.post(Uri.parse(url), body: {
//         'lid': lid
//       });
//
//       var jsondata = json.decode(data.body);
//       String statusMsg = jsondata['status'];
//
//       var arr = jsondata["data"];
//
//       print(arr.length);
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         date.add(arr[i]['date'].toString());
//         complaint.add(arr[i]['complaint'].toString());
//         reply.add(arr[i]['reply'].toString());
//         status.add(arr[i]['status'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         date_ = date;
//         complaint_ = complaint;
//         reply_ = reply;
//         status_ = status;
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
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           leading: BackButton(onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => HomeNew()),
//             );
//           }),
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           title: Text(widget.title),
//         ),
//         body: ListView.builder(
//           physics: BouncingScrollPhysics(),
//           itemCount: id_.length,
//           itemBuilder: (BuildContext context, int index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
//               child: Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Date: ${date_[index]}',
//                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Complaint: ${complaint_[index]}',
//                         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Reply: ${reply_[index]}',
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Status: ${status_[index]}',
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: status_[index] == 'Resolved' ? Colors.green : Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => Mysendcomplaintpage(title: '',)),
//             );
//           },
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           child: const Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendfitapp/Home.dart';
import 'package:trendfitapp/pages/bottomnavigationbar.dart';
import 'package:trendfitapp/pages/settingsscreen.dart';
import 'package:trendfitapp/pages/test.dart';
import 'Send complaint.dart';

void main() {
  runApp(const ViewReply());
}

class ViewReply extends StatelessWidget {
  const ViewReply({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Reply',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2DD376)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7FBF8),
      ),
      home: const ViewReplyPage(title: 'Complaints & Replies'),
    );
  }
}

class ViewReplyPage extends StatefulWidget {
  const ViewReplyPage({super.key, required this.title});

  final String title;

  @override
  State<ViewReplyPage> createState() => _ViewReplyPageState();
}

class _ViewReplyPageState extends State<ViewReplyPage> {
  // Lists for data
  List<String> id_ = <String>[];
  List<String> date_ = <String>[];
  List<String> complaint_ = <String>[];
  List<String> reply_ = <String>[];
  List<String> status_ = <String>[];

  // Loading / error state
  bool isLoading = true;
  bool isError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    viewReply();
  }

  Future<void> viewReply() async {
    setState(() {
      isLoading = true;
      isError = false;
      errorMessage = '';
    });

    List<String> id = <String>[];
    List<String> date = <String>[];
    List<String> complaint = <String>[];
    List<String> reply = <String>[];
    List<String> status = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/view_reply_user/';

      var data = await http.post(Uri.parse(url), body: {
        'lid': lid
      });

      if (data.statusCode != 200) {
        throw Exception('Network error: ${data.statusCode}');
      }

      var jsondata = json.decode(data.body);

      // handle possible shapes and missing fields gracefully
      if (jsondata == null) {
        throw Exception('Invalid server response');
      }

      String statusMsg = '';
      if (jsondata is Map && jsondata.containsKey('status')) {
        statusMsg = jsondata['status'].toString();
      }

      var arr;
      if (jsondata is Map && jsondata.containsKey('data')) {
        arr = jsondata["data"];
      } else if (jsondata is List) {
        arr = jsondata;
      } else {
        arr = [];
      }

      if (arr is! List) {
        arr = [];
      }

      for (int i = 0; i < arr.length; i++) {
        final item = arr[i] ?? {};
        id.add((item['id'] ?? '').toString());
        date.add((item['date'] ?? '').toString());
        complaint.add((item['complaint'] ?? '').toString());
        reply.add((item['reply'] ?? '').toString());
        status.add((item['status'] ?? '').toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        complaint_ = complaint;
        reply_ = reply;
        status_ = status;
        isLoading = false;
      });

      print(statusMsg);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      setState(() {
        isLoading = false;
        isError = true;
        errorMessage = e.toString();
      });
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }

  Color _statusDotColor(String status) {
    if (status.toLowerCase().contains('resolved')) return const Color(0xFF2DD376);
    if (status.toLowerCase().contains('pending')) return const Color(0xFFFFC107);
    return Colors.grey;
  }

  Color _statusBgColor(String status) {
    if (status.toLowerCase().contains('resolved')) return const Color(0xFFEFFAF2);
    if (status.toLowerCase().contains('pending')) return const Color(0xFFFFF7E6);
    return Colors.grey.shade200;
  }

  Widget _noComplaintsView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'No Complaints Found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          const Text(
            'You have not submitted any complaints yet.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _errorView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 12),
          const Text('Something went wrong', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(errorMessage, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: viewReply,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2DD376),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // main page scaffold
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading:  IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>BottomNavBar(initialIndex: 3),)),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF7FBF8),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          child: Builder(
            builder: (_) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (isError) {
                return _errorView();
              } else if (id_.isEmpty) {
                // No complaints found
                return _noComplaintsView();
              } else {
                // Show list
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: id_.length,
                  itemBuilder: (BuildContext context, int index) {
                    final status = status_[index];
                    final resolved = status.toLowerCase().contains('resolved');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFDFF3E8), width: 1.4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // top row: Complaint title + status pill
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Complaint',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          date_[index],
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF2DD376),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // status pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _statusBgColor(status),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: _statusDotColor(status),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          status,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: _statusDotColor(status),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // complaint text
                              Text(
                                complaint_[index],
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),

                              // show divider and reply only if reply exists or status resolved
                              if ((reply_[index].trim().isNotEmpty))
                                ...[
                                  const SizedBox(height: 12),
                                  Divider(color: Colors.grey.shade300, thickness: 1),
                                  const SizedBox(height: 12),

                                  const Text(
                                    'Customer Service Reply',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  Text(
                                    reply_[index],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.6,
                                      color: Color(0xFF2DD376),
                                    ),
                                  ),
                                ],

                              // small spacing bottom
                              const SizedBox(height: 2),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Mysendcomplaintpage(title: '',)),
            );
          },
          backgroundColor: const Color(0xFF2DD376),
          child: const Icon(Icons.add, size: 30),
          elevation: 6,
        ),
      ),
    );
  }
}
