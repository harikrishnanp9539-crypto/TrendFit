import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Local placeholder image supplied in the conversation
const String kLocalPlaceholderImage = '/mnt/data/screen.png';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Cart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F8F6),
        primarySwatch: Colors.green,
      ),
      home: const ViewCartScreen(),
    );
  }
}

class ViewCartScreen extends StatefulWidget {
  const ViewCartScreen({super.key});

  @override
  State<ViewCartScreen> createState() => _ViewCartScreenState();
}

class _ViewCartScreenState extends State<ViewCartScreen> {
  late Razorpay _razorpay;
  bool _loading = true;
  final List<CartItem> _items = [];
  double shipping = 51.00; // fixed shipping
  String _serverTotal = "0";
  @override
  void initState() {
    super.initState();
    _initRazorpay();
    _loadCart();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  // Razorpay callbacks
  void _onPaymentSuccess(PaymentSuccessResponse response) {
    _confirmPaymentToServer();
    Fluttertoast.showToast(msg: "Payment Successful!");
  }

  void _onPaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed: ${response.message}");
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External wallet: ${response.walletName}");
  }

  Future<void> _openCheckout(double amount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = prefs.getString('rzp_key') ?? 'rzp_test_HKCAwYtLt0rwQe';
      final int amountInPaise = (amount * 100).round();

      var options = {
        'key': key,
        'amount': amountInPaise,
        'name': 'TrendFit',
        'description': 'Order payment',
        'prefill': {'contact': '', 'email': ''},
        'external': {
          'wallets': ['paytm']
        }
      };

      _razorpay.open(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error opening checkout: $e');
    }
  }

  /// Fetch cart data from server (endpoint: view_cart_and_order/)
  Future<void> _loadCart() async {
    setState(() => _loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = prefs.getString('url') ?? '';
      final lid = prefs.getString('lid') ?? '';
      final imgPrefix = prefs.getString('img') ?? prefs.getString('img_url') ?? '';

      if (baseUrl.isEmpty) {
        Fluttertoast.showToast(msg: 'Server URL missing in SharedPreferences');
        setState(() => _loading = false);
        return;
      }

      final uri = Uri.parse('$baseUrl/view_cart_and_order/');
      final resp = await http.post(uri, body: {'lid': lid});
      if (resp.statusCode != 200) {
        Fluttertoast.showToast(msg: 'Network error: ${resp.statusCode}');
        setState(() => _loading = false);
        return;
      }

      final jsonData = jsonDecode(resp.body);
      if (jsonData['status'] == 'ok') {
        final List<dynamic> arr = jsonData['data'] ?? [];
        final List<CartItem> loaded = [];
        for (var item in arr) {
          loaded.add(CartItem(
            id: item['id'].toString(),
            title: item['Dress name']?.toString() ?? '',
            size: item['Dress size']?.toString() ?? '',
            photo: (imgPrefix + (item['Dress_photo']?.toString() ?? '')).trim(),
            qty: int.tryParse(item['quantity']?.toString() ?? '1') ?? 1,
            price: double.tryParse(item['Dress price']?.toString() ?? '0') ?? 0.0,
            shopName: item['Shop name']?.toString() ?? '',
          ));
        }

        setState(() {
          _items.clear();
          _items.addAll(loaded);
          _serverTotal = (jsonData['tot'] ?? '0').toString();
        });
      } else {
        Fluttertoast.showToast(msg: 'No items in cart');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error loading cart: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Remove item from server cart (endpoint: deletefromcart/)
  Future<void> _deleteItem(String cid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = prefs.getString('url') ?? '';
      if (baseUrl.isEmpty) {
        Fluttertoast.showToast(msg: 'Server URL missing');
        return;
      }
      final uri = Uri.parse('$baseUrl/deletefromcart/');
      final resp = await http.post(uri, body: {'cid': cid});
      if (resp.statusCode == 200) {
        final jsonData = jsonDecode(resp.body);
        if (jsonData['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Item deleted');
          await _loadCart();
        } else {
          Fluttertoast.showToast(msg: 'Failed to delete item');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error: ${resp.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error deleting item: $e');
    }
  }

  /// After successful payment notify server (endpoint: user_makepayment/)
  Future<void> _confirmPaymentToServer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = prefs.getString('url') ?? '';
      final lid = prefs.getString('lid') ?? '';
      if (baseUrl.isEmpty) return;

      final uri = Uri.parse('$baseUrl/user_makepayment/');
      final resp = await http.post(uri, body: {'lid': lid});
      if (resp.statusCode == 200) {
        final j = jsonDecode(resp.body);
        if (j['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Payment recorded on server');
          // Optionally refresh cart
          await _loadCart();
        } else {
          Fluttertoast.showToast(msg: 'Server payment failed');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error sending payment');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error sending payment: $e');
    }
  }

  double get subtotal {
    double s = 0;
    for (var it in _items) {
      s += it.price * it.qty;
    }
    return s;
  }

  double get total => subtotal + shipping;

  void _changeQty(int index, int delta) {
    setState(() {
      final current = _items[index].qty;
      final next = (current + delta).clamp(1, 99);
      _items[index] = _items[index].copyWith(qty: next);
    });
    // Optionally call server to update quantity for persistence
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.of(context).maybePop()),
        title: const Text('My Cart', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? const Center(child: Text('Your cart is empty.', style: TextStyle(fontSize: 18)))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final it = _items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: (it.photo.isNotEmpty)
                              ? Image.network(
                            it.photo,
                            width: 100,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              kLocalPlaceholderImage,
                              width: 100,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Image.asset(
                            kLocalPlaceholderImage,
                            width: 100,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(it.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text('Size: ${it.size}', style: TextStyle(color: Colors.grey[700])),
                              Text('Shop: ${it.shopName}', style: TextStyle(color: Colors.grey[700])),
                              const SizedBox(height: 8),
                              Text('\$${it.price.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF22D583), fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(height: 12),

                              // Qty controls
                              Row(
                                children: [
                                  _QtyButton(icon: Icons.remove, onTap: () => _changeQty(index, -1)),
                                  const SizedBox(width: 12),
                                  Text(it.qty.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 12),
                                  _QtyButton(icon: Icons.add, onTap: () => _changeQty(index, 1)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Delete icon
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.grey[600]),
                          onPressed: () => _deleteItem(it.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom summary
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Subtotal', style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  Text('\$${subtotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                ]),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Shipping', style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  Text('\$${shipping.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                ]),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _openCheckout(total),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22D583),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small reusable qty circular button
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black54),
      ),
    );
  }
}

/// Simple immutable cart model
class CartItem {
  final String id;
  final String title;
  final String size;
  final String photo;
  final int qty;
  final double price;
  final String shopName;

  const CartItem({
    required this.id,
    required this.title,
    required this.size,
    required this.photo,
    required this.qty,
    required this.price,
    required this.shopName,
  });

  CartItem copyWith({int? qty}) {
    return CartItem(
      id: id,
      title: title,
      size: size,
      photo: photo,
      qty: qty ?? this.qty,
      price: price,
      shopName: shopName,
    );
  }
}
