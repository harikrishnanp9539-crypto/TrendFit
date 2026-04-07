import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trendfitapp/pages/Cart%20Page.dart';
import 'package:trendfitapp/pages/test.dart';

import 'homesrn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Stylist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF9F9),
        useMaterial3: false,
      ),
      home: const UploadScreen(),
    );
  }
}

/// Upload screen UI (matches first screenshot)
class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? picked =
      await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error picking image: $e');
    }
  }

  // Send only to recommendations backend when pressing Get Recommendations
  Future<void> _getRecommendations() async {
    if (_selectedImage == null) {
      Fluttertoast.showToast(msg: 'Please upload an image first.');
      return;
    }
    setState(() => _isUploading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String urlBase = prefs.getString('url') ?? '';
      if (urlBase.isEmpty) {
        Fluttertoast.showToast(msg: 'Missing server url in SharedPreferences');
        setState(() => _isUploading = false);
        return;
      }

      // Navigate to list screen and let it perform the upload & fetch.
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => RecommendationListScreen(
            imageFile: _selectedImage!,
          )));
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _clearImage() {
    setState(() => _selectedImage = null);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).maybePop()),
        centerTitle: true,
        title: const Text(
          'AI Stylist',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
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
                    'Personalized\nRecommendations',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      height: 1.05,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Find dresses that match your style. Upload a photo to get started.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // dashed upload area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: GestureDetector(
                onTap: _pickImage,
                child: CustomPaint(
                  painter: DashedRectPainter(
                    color: const Color(0xFF9ACFB0),
                    strokeWidth: 2,
                    radius: 12,
                    gap: 8,
                    dashWidth: 6,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 320,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                    child: Center(
                      child: _selectedImage != null
                          ? Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: _clearImage,
                          ),
                        ],
                      )
                          : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.image_outlined,
                              size: 56,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Tap to upload an image',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Upload a photo of yourself or a style you love',
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          const SizedBox(height: 22),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 26, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDFF2E6),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                'Upload Image',
                                style: TextStyle(
                                    color: Color(0xFF1B6E3B),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // spacer
            const Spacer(),

            // Bottom large button
            SafeArea(
              top: false,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: SizedBox(
                  width: width,
                  height: 62,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _getRecommendations,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B7A3A),
                      shape: const StadiumBorder(),
                      elevation: 4,
                    ),
                    child: _isUploading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      'Get Recommendations',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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

/// A screen that uploads the image and displays the recommendations list (second screenshot).
class RecommendationListScreen extends StatefulWidget {
  final File imageFile;
  const RecommendationListScreen({super.key, required this.imageFile});

  @override
  State<RecommendationListScreen> createState() =>
      _RecommendationListScreenState();
}

class _RecommendationListScreenState extends State<RecommendationListScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  // <-- MINIMAL CHANGE: send base64 in 'Photo' field to match Django view ----------
  Future<void> _fetchRecommendations() async {
    setState(() => _loading = true);
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      final String baseUrl = sh.getString('url') ?? '';
      final String imgPrefix = sh.getString('img') ?? '';

      if (baseUrl.isEmpty) {
        Fluttertoast.showToast(msg: 'Missing server url in SharedPreferences');
        setState(() => _loading = false);
        return;
      }

      final uri = Uri.parse('$baseUrl/recommendations/');

      // read image bytes and encode to base64
      final bytes = await widget.imageFile.readAsBytes();
      final String b64 = base64Encode(bytes);

      // include lid if available
      final lid = sh.getString('lid') ?? '';

      // send as form body (application/x-www-form-urlencoded)
      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'Photo': b64,
          if (lid.isNotEmpty) 'lid': lid,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'ok') {
          final List<Map<String, dynamic>> temp = [];
          for (var item in jsonData['data']) {
            temp.add({
              'id': item['id'] ?? '',
              'Photo': (imgPrefix + (item['Photo'] ?? '')),
              'Dress name': item['Dress name'] ?? '',
              'Description': item['Description'] ?? '',
              'Price': item['Price'] ?? '',
              'dress type': item['dress type'] ?? '',
            });
          }
          setState(() => users = temp);
        } else {
          Fluttertoast.showToast(msg: 'No recommendations returned');
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }


  Widget _buildCard(Map<String, dynamic> item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      elevation: 3,
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: item['Photo'] != null && item['Photo'] != ''
                  ? Image.network(
                item['Photo'],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: Text('Image error')),
                ),
              )
                  : Container(
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.image, size: 56)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // left column with labels and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['dress type'] ?? '',
                        style: TextStyle(
                          color: const Color(0xFF1B7A3A),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['Dress name'] ?? '',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['Description'] ?? '',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '\$${item['Price'] ?? '0'}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // Right side: heart and Add to cart
                Column(
                  children: [
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MydressMore(
                              title: '',
                              dressId: (item['id'].toString()),
                            ),
                          ),
                        );





                      },
                      child: Text("Add to cart"),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Recommendations'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No recommendations found',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchRecommendations,
              child: const Text('Try again'),
            )
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.only(bottom: 18),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return _buildCard(users[index]);
        },
      ),
    );
  }
}

/// Custom painter for dashed rounded rectangle border.
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
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

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
