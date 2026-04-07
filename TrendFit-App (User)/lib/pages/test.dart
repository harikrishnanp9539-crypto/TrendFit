import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendfitapp/pages/Cart%20Page.dart';

import 'bottomnavigationbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MydressMore(
        title: 'Add to Cart',
        dressId: '1', // Pass the dress ID when navigating
      ),
    );
  }
}

class MydressMore extends StatefulWidget {
  const MydressMore({
    super.key,
    required this.title,
    required this.dressId,
  });

  final String title;
  final String dressId;

  @override
  State<MydressMore> createState() => _MydressMoreState();
}

class _MydressMoreState extends State<MydressMore> {
  int quantity = 1;
  String selectedSize = 'S';
  bool _loading = true;

  Map<String, dynamic> dressData = {};

  @override
  void initState() {
    super.initState();
    fetchDressDetails();
  }

  Future<void> fetchDressDetails() async {
    setState(() => _loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = prefs.getString('url') ?? '';
      final imageUrl = prefs.getString('img') ?? '';

      if (baseUrl.isEmpty) {
        Fluttertoast.showToast(msg: 'Server URL missing in SharedPreferences');
        setState(() => _loading = false);
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/view_dress_rec/'),
        body: {'id': widget.dressId},
      );
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        final data = jsonData['data'];
        if (data != null && data.isNotEmpty) {
          final item = data[0]; // Get first item or find by ID
          setState(() {
            dressData = {
              'id': item['id'] ?? '',
              'photo': imageUrl + (item['photo'] ?? ''),
              'name': item['name'] ?? 'Floral Dress',
              'type': item['type'] ?? '',
              'size': item['size'] ?? 'S,M,L,XL',
              'price': item['price'] ?? '89.99',
              'description': item['description'] ?? 'Elevate your style with this beautiful floral dress. Perfect for spring outings and special occasions.',
              'material': item['material'] ?? '100% Cotton',
              'style': item['style'] ?? 'A-Line, Midi Length',
              'care': item['care'] ?? 'Machine wash cold, tumble dry low',
            };
            // Set default size from available sizes
            List<String> sizes = dressData['size'].toString().split(',');
            if (sizes.isNotEmpty) {
              selectedSize = sizes[0].trim();
            }
          });
        }
      } else {
        Fluttertoast.showToast(msg: 'Dress not found');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching dress: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: Colors.green))
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image and Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Container(
                        width: 200,
                        height: 260,
                        decoration: BoxDecoration(
                          color: Color(0xFFD9B5A0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            dressData['photo'] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(Icons.image,
                                    size: 50, color: Colors.white),
                              );
                            },
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      // Product Name and Price
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dressData['name'] ?? 'Floral Dress',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '\$${dressData['price'] ?? '89.99'}',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    dressData['description'] ??
                        'Elevate your style with this beautiful floral dress. Perfect for spring outings and special occasions.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Product Details
                  _buildDetailRow(
                      'Material:', dressData['material'] ?? '100% Cotton'),
                  SizedBox(height: 8),
                  _buildDetailRow('Style:',
                      dressData['style'] ?? 'A-Line, Midi Length'),
                  SizedBox(height: 8),
                  _buildDetailRow('Care:',
                      dressData['care'] ?? 'Machine wash cold, tumble dry low'),
                  SizedBox(height: 30),

                  // Size Selection
                  Text(
                    'Size',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildSizeSelector(),
                  SizedBox(height: 30),

                  // Quantity Selection
                  Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      SizedBox(width: 20),
                      Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 20),
                      _buildQuantityButton(
                        icon: Icons.add,
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Bottom Buttons
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      senddata();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>BottomNavBar(initialIndex: 3),));
                  },
                  child: Text(
                    'View Cart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•  ',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSelector() {
    List<String> availableSizes = [];
    if (dressData['size'] != null && dressData['size'].toString().isNotEmpty) {
      availableSizes = dressData['size']
          .toString()
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    } else {
      availableSizes = ['S', 'M', 'L', 'XL'];
    }

    return Wrap(
      spacing: 12,
      children: availableSizes.map((size) => _buildSizeButton(size)).toList(),
    );
  }

  Widget _buildSizeButton(String size) {
    bool isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.green : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.grey[700]),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Future<void> senddata() async {
    String quantityStr = quantity.toString();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/add_to_cart/');
    try {
      final response = await http.post(urls, body: {
        'Quantity': quantityStr,
        'DRESS': widget.dressId,
        'lid': lid,
        'selectedSize': selectedSize,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Added to cart successfully!');
          Navigator.push(context, MaterialPageRoute(builder: (context) =>BottomNavBar(initialIndex: 2),));
        } else {
          Fluttertoast.showToast(msg: 'Failed to add to cart');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}