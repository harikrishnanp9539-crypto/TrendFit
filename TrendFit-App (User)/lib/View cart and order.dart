
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendfitapp/Home.dart';

void main() {
  runApp(const ViewSlot());
}

class ViewSlot extends StatelessWidget {
  const ViewSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Materials',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF184A2C)),
        useMaterial3: true,
      ),
      home: const Viewcart(title: ''),
    );
  }
}

class Viewcart extends StatefulWidget {
  const Viewcart({super.key, required this.title});

  final String title;

  @override
  State<Viewcart> createState() => _ViewcartState();
}

class _ViewcartState extends State<Viewcart> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    ViewSlot();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {

    senddata();


    // Handle successful payment
    Fluttertoast.showToast(msg: "Payment Successful!");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    Fluttertoast.showToast(msg: "Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    Fluttertoast.showToast(msg: "External Wallet: ${response.walletName}");
  }

  Future<void> _openCheckout() async{
    int am = int.parse(amount_) * 1000;

    var options = {
      'key': 'rzp_test_HKCAwYtLt0rwQe', // Replace with your Razorpay API key
      'amount': am, // Amount in paise (e.g. 2000 paise = Rs 20)
      'name': 'Flutter Razorpay Example',
      'description': 'Payment for the product',
      'prefill': {'contact': '9747360170', 'email': 'tlikhil@gmail.com'},
      'external': {
        'wallets': ['paytm'] // List of external wallets
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  String amount_ = "0";
  List<String> id_ = <String>[];
  List<String> quantity_ = <String>[];
  List<String> dressname_ = <String>[];
  List<String> dresssize_ = <String>[];
  List<String> dressphoto_ = <String>[];
  List<String> dressprice_ = <String>[];
  List<String> shopname_ = <String>[];

  Future<void> ViewSlot() async {
    List<String> id = <String>[];
    List<String> quantity = <String>[];
    List<String> dressname = <String>[];
    List<String> dresssize = <String>[];
    List<String> dressphoto = <String>[];
    List<String> dressprice = <String>[];
    List<String> shopname = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String img = sh.getString('img').toString();
      String url = '$urls/view_cart_and_order/';

      var data = await http.post(Uri.parse(url), body: {
        'lid': lid
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];
      String amount = jsondata['tot'].toString();

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        quantity.add(arr[i]['quantity'].toString());
        dressname.add(arr[i]['Dress name'].toString());
        dresssize.add(arr[i]['Dress size'].toString());
        dressphoto.add(sh.getString('img').toString() + arr[i]['Dress_photo']);
        dressprice.add(arr[i]['Dress price'].toString());
        shopname.add(arr[i]['Shop name'].toString());
      }

      setState(() {
        id_ = id;
        quantity_ = quantity;
        dressname_ = dressname;
        dresssize_ = dresssize;
        dressphoto_ = dressphoto;
        dressprice_ = dressprice;
        shopname_ = shopname;
        amount_ = amount;
      });
    } catch (e) {
      print("Network Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: 'home')),
              );
            },
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(widget.title),
          actions: [
            Text(amount_),
            IconButton(
              icon: Icon(Icons.payment),
              onPressed: () {
                _openCheckout();
              },
            ),
          ],
        ),
        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: id_.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8,
                child: Stack(
                  children: [
                    // Background image
                    Container(
                      width: double.infinity,
                      height: 250,
                      child: Image.network(
                        dressphoto_[index], // Your image URL here
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Overlay text
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Text(
                        dressname_[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Content below image
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.black.withOpacity(0.5), // Overlay color
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantity: ${quantity_[index]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Price: ${dressprice_[index]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Size: ${dresssize_[index]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Delete button on top right
                    Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton(
                        onPressed: () async {
                          try {
                            SharedPreferences sh =
                            await SharedPreferences.getInstance();
                            String urls = sh.getString('url').toString();
                            String url = '$urls/deletefromcart/';

                            var data = await http.post(Uri.parse(url), body: {
                              'cid': id_[index]
                            });

                            var jsondata = json.decode(data.body);
                            String statuss = jsondata['status'];

                            if(statuss == "ok"){
                              Fluttertoast.showToast(msg: "Item deleted");
                              ViewSlot();

                            }
                            else{
                              Fluttertoast.showToast(msg: "Not deleted");

                            }


                          } catch (e) {
                            print("Network Error: $e");
                          }
                        },
                        icon: Icon(
                          Icons.clear, // Cross icon
                          color: Colors.red, // Red color
                        ),
                        tooltip: 'Remove from Cart',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  void senddata() async {
    // String name = Namecontroller.text;
    // String place = Placenamecontroller.text;


    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/user_makepayment/');
    try {
      final response = await http.post(urls, body: {
        'lid': lid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Payment Successful!');
          Viewcart(title: '',);
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
