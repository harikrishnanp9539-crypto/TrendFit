
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:trendfitapp/pages/test.dart';
import 'package:trendfitapp/pages/viewordersub.dart';

void main() {
  runApp(const MyApp());
}

/// ENTRY APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrendFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.green,
      ),
      home: const DressUpHomePage(),
    );
  }
}

/// HOME PAGE
class DressUpHomePage extends StatefulWidget {
  const DressUpHomePage({super.key});

  @override
  State<DressUpHomePage> createState() => _DressUpHomePageState();
}

class _DressUpHomePageState extends State<DressUpHomePage> {
  List<Map<String, dynamic>> dresses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchDresses();
  }

  Future<void> fetchDresses() async {
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

      final response = await http.post(Uri.parse('$baseUrl/view_dress_user/'));
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        final List<Map<String, dynamic>> tmp = [];
        for (var item in jsonData['data']) {
          tmp.add({
            'id': item['id'],
            'photo': imageUrl + (item['photo'] ?? ''),
            'name': item['name'] ?? '',
            'type': item['type'] ?? '',
            'size': item['size'] ?? '',
            'price': item['price'] ?? '0',
          });
        }
        setState(() => dresses = tmp);
      } else {
        Fluttertoast.showToast(msg: 'No dresses found');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching dresses: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      title: const Text("TrendFit", style: TextStyle(color: Colors.black)),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Viewodersub(title: ''),));
            // Fluttertoast.showToast(msg: 'Open Orders (not implemented)');
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search for dresses",
        prefixIcon: const Icon(Icons.search, color: Color(0xFF149B0C)),
        fillColor: const Color(0xFFCEF1C8),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildNewArrivals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("New Arrivals"),
        const SizedBox(height: 10),
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: AssetImage('assets/img/2mengreen.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(16),
          child: const Text(
            "New Arrivals",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _categoryItem(String title, String imgPath) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _categoryItem("Summer", 'assets/img/wo1.jpg'),
        _categoryItem("Party", 'assets/img/wo2.jpg'),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  List<Widget> _buildFeaturedDresses() {
    return dresses.map((dress) {
      return Card(
        color: Colors.green.shade50,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              dress['photo'],
              width: 60,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          title: Text(dress['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Category: ${dress['type']}"),
              Text("Price: \$${dress['price']}"),
            ],
          ),
          trailing: ElevatedButton(
            onPressed: () async {
              final sh = await SharedPreferences.getInstance();
              await sh.setString('did', dress['id'].toString());

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MydressMore(title: '', dressId: dress['id'].toString())),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text("Add to cart"),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: RefreshIndicator(
          onRefresh: fetchDresses,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildNewArrivals(),
              const SizedBox(height: 20),
              _buildSectionTitle("Popular Categories"),
              const SizedBox(height: 12),
              _buildCategories(),
              const SizedBox(height: 20),
              _buildSectionTitle("Featured Dresses"),
              const SizedBox(height: 12),
              _loading
                  ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                  : Column(children: _buildFeaturedDresses()),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(const MyApp());
// }
//
// /// ENTRY APP
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'TrendFit',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//         primarySwatch: Colors.green,
//       ),
//       home: const DressUpHomePage(),
//     );
//   }
// }
//
// /// HOME PAGE
// class DressUpHomePage extends StatefulWidget {
//   const DressUpHomePage({super.key});
//
//   @override
//   State<DressUpHomePage> createState() => _DressUpHomePageState();
// }
//
// class _DressUpHomePageState extends State<DressUpHomePage> {
//   List<Map<String, dynamic>> dresses = [];
//   bool _loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDresses();
//   }
//
//   Future<void> fetchDresses() async {
//     setState(() => _loading = true);
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final baseUrl = prefs.getString('url') ?? '';
//       final imageUrl = prefs.getString('img') ?? '';
//
//       if (baseUrl.isEmpty) {
//         Fluttertoast.showToast(msg: 'Server URL missing in SharedPreferences');
//         setState(() => _loading = false);
//         return;
//       }
//
//       final response = await http.post(Uri.parse('$baseUrl/view_dress_user/'));
//       final jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         final List<Map<String, dynamic>> tmp = [];
//         for (var item in jsonData['data']) {
//           tmp.add({
//             'id': item['id'],
//             'photo': imageUrl + (item['photo'] ?? ''),
//             'name': item['name'] ?? '',
//             'type': item['type'] ?? '',
//             'size': item['size'] ?? '',
//             'price': item['price'] ?? '0',
//           });
//         }
//         setState(() => dresses = tmp);
//       } else {
//         Fluttertoast.showToast(msg: 'No dresses found');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error fetching dresses: $e');
//     } finally {
//       setState(() => _loading = false);
//     }
//   }
//
//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       automaticallyImplyLeading: false,
//       elevation: 0,
//       centerTitle: true,
//       title: const Text("TrendFit", style: TextStyle(color: Colors.black)),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
//           onPressed: () async {
//             // If you have a ViewOrders page, navigate to it here.
//             // Navigator.push(context, MaterialPageRoute(builder: (_) => ViewOrders(title: '')));
//             Fluttertoast.showToast(msg: 'Open Orders (not implemented)');
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return TextField(
//       decoration: InputDecoration(
//         hintText: "Search for dresses",
//         prefixIcon: const Icon(Icons.search, color: Color(0xFF149B0C)),
//         fillColor: const Color(0xFFCEF1C8),
//         filled: true,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNewArrivals() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle("New Arrivals"),
//         const SizedBox(height: 10),
//         Container(
//           height: 180,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             image: const DecorationImage(
//               image: AssetImage('assets/img/2mengreen.jpg'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           alignment: Alignment.bottomLeft,
//           padding: const EdgeInsets.all(16),
//           child: const Text(
//             "New Arrivals",
//             style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _categoryItem(String title, String imgPath) {
//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             height: 120,
//             margin: const EdgeInsets.symmetric(horizontal: 8),
//             decoration: BoxDecoration(
//               image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.cover),
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategories() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _categoryItem("Summer", 'assets/img/2mengreen.jpg'),
//         _categoryItem("Party", 'assets/img/2mengreen.jpg'),
//       ],
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
//   }
//
//   List<Widget> _buildFeaturedDresses() {
//     return dresses.map((dress) {
//       return Card(
//         color: Colors.green.shade50,
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         child: ListTile(
//           contentPadding: const EdgeInsets.all(12),
//           leading: ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(
//               dress['photo'],
//               width: 60,
//               height: 80,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => Container(
//                 width: 60,
//                 height: 80,
//                 color: Colors.grey[200],
//                 child: const Icon(Icons.image, color: Colors.grey),
//               ),
//             ),
//           ),
//           title: Text(dress['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Category: ${dress['type']}"),
//               Text("Price: \$${dress['price']}"),
//             ],
//           ),
//           trailing: ElevatedButton(
//             onPressed: ()
//             async {
//               final sh = await SharedPreferences.getInstance();
//               await sh.setString('did', dress['id'].toString());
//
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => AddToCartScreen(dress: dress)),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text("Add to cart"),
//           ),
//         ),
//       );
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         appBar: _buildAppBar(),
//         body: RefreshIndicator(
//           onRefresh: fetchDresses,
//           child: ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               _buildSearchBar(),
//               const SizedBox(height: 20),
//               _buildNewArrivals(),
//               const SizedBox(height: 20),
//               _buildSectionTitle("Popular Categories"),
//               const SizedBox(height: 12),
//               _buildCategories(),
//               const SizedBox(height: 20),
//               _buildSectionTitle("Featured Dresses"),
//               const SizedBox(height: 12),
//               _loading
//                   ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
//                   : Column(children: _buildFeaturedDresses()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// ADD TO CART SCREEN (full-screen)
// class AddToCartScreen extends StatefulWidget {
//   final Map<String, dynamic> dress;
//   const AddToCartScreen({super.key, required this.dress});
//
//   @override
//   State<AddToCartScreen> createState() => _AddToCartScreenState();
// }
//
// class _AddToCartScreenState extends State<AddToCartScreen> {
//   String selectedSize = 'S';
//   int quantity = 1;
//   // final List<Color> colors = [
//   //   const Color(0xFF6A1B9A), // purple
//   //   const Color(0xFF1E88E5), // blue
//   //   const Color(0xFFE53935), // red
//   //   const Color(0xFF2E7D32), // green
//   // ];
//   // int selectedColorIndex = 0;
//
//   Future<void> _addToCart() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final url = prefs.getString('url') ?? '';
//       final lid = prefs.getString('lid') ?? '';
//
//       if (url.isEmpty || lid.isEmpty) {
//         Fluttertoast.showToast(msg: 'Missing url or lid in SharedPreferences');
//         return;
//       }
//
//       final api = Uri.parse('$url/add_to_cart/'); // replace with your actual endpoint
//       final response = await http.post(api, body: {
//         'lid': lid,
//         'did': widget.dress['id'].toString(),
//         'qty': quantity.toString(),
//         'size': selectedSize,
//       });
//
//       final data = json.decode(response.body);
//       if (response.statusCode == 200 && data['status'] == 'ok') {
//         Fluttertoast.showToast(msg: 'Added to cart');
//         Navigator.of(context).pop(); // go back to home or list
//       } else {
//         Fluttertoast.showToast(msg: 'Failed to add to cart');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dress = widget.dress;
//     final imageUrl = dress['photo'] as String? ?? '';
//     final title = (dress['DREESS'] as String?) ?? '';
//     final price = (dress['price']?.toString()) ?? '0';
//     final description = (dress['Description'] as String?) ?? '';
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F8F6),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.of(context).pop()),
//         title: const Text('Add to Cart', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 18.0),
//           child: ListView(
//             children: [
//               const SizedBox(height: 8),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: imageUrl.isNotEmpty
//                         ? Image.network(imageUrl, width: 120, height: 160, fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(width: 120, height: 160, color: Colors.grey[200], child: const Icon(Icons.image, size: 40)))
//                         : Container(width: 120, height: 160, color: Colors.grey[200], child: const Icon(Icons.image, size: 40)),
//                   ),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
//                         const SizedBox(height: 8),
//                         Text('\$${price}', style: const TextStyle(fontSize: 22, color: Color(0xFF22D583), fontWeight: FontWeight.w700)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//               const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
//               const SizedBox(height: 10),
//               Text(description, style: const TextStyle(fontSize: 16, color: Colors.black87)),
//               const SizedBox(height: 16),
//
//               const SizedBox(height: 12),
//               const Text('Size', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//               const SizedBox(height: 12),
//               Row(
//                 children: ['S', 'M', 'L', 'XL'].map((s) {
//                   final selected = selectedSize == s;
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 12.0),
//                     child: GestureDetector(
//                       onTap: () => setState(() => selectedSize = s),
//                       child: Container(
//                         width: 44,
//                         height: 44,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: selected ? const Color(0xFFDFFBEA) : Colors.white,
//                           border: Border.all(color: selected ? const Color(0xFF22D583) : Colors.grey.shade300),
//                         ),
//                         child: Text(s, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: selected ? const Color(0xFF22D583) : Colors.black87)),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//
//               const SizedBox(height: 20),
//               const Text('Quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => setState(() {
//                       if (quantity > 1) quantity--;
//                     }),
//                     child: Container(
//                       width: 44,
//                       height: 44,
//                       decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: Colors.grey.shade300)),
//                       child: const Icon(Icons.remove),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Text(quantity.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//                   const SizedBox(width: 16),
//                   GestureDetector(
//                     onTap: () => setState(() => quantity++),
//                     child: Container(
//                       width: 44,
//                       height: 44,
//                       decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: Colors.grey.shade300)),
//                       child: const Icon(Icons.add),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 28),
//
//               // Add to cart button + view cart link
//               Column(
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: _addToCart,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF22D583),
//                         shape: const StadiumBorder(),
//                       ),
//                       child: const Text('Add to Cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   GestureDetector(
//                     onTap: () {
//                       // Navigate to cart page if you have it
//                       Fluttertoast.showToast(msg: 'Open cart (not implemented)');
//                     },
//                     child: const Text('View Cart', style: TextStyle(color: Color(0xFF22D583), fontWeight: FontWeight.w600)),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
