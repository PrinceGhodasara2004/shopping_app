// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shopping_app/screens/bottomnav.dart';
import 'package:shopping_app/services/databse.dart';
import 'package:shopping_app/services/shared_pref.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class AddUserDetailsScreen extends StatefulWidget {
  String name, details, price, image;

  AddUserDetailsScreen({
    super.key,
    required this.name,
    required this.details,
    required this.price,
    required this.image,
  });

  @override
  State<AddUserDetailsScreen> createState() => _AddUserDetailsScreenState();
}

class _AddUserDetailsScreenState extends State<AddUserDetailsScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? name, email, phoneNumber, address, id;

  getUserDataSP() async {
    id = await SharedPreferenceHelper().getUserId();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserDataSP();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String orderId = randomAlphaNumeric(10);
    Map<String, dynamic> orderInfoMap = {
      "ProductName": widget.name,
      "ProductPrice": widget.price,
      "ProductImage": widget.image,
      "UserName": name,
      "UserEmail": email,
      "PhoneNumber": phoneController.text,
      "UserAddress": addressController.text,
      "Tracker": 0,
      "OrderId": orderId,
      "UserId": id,
    };

    await DatabseMethods().userOrderDetails(orderInfoMap, id!, orderId);
    await DatabseMethods().orderDetails(orderInfoMap);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BottomNavScreen()),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  final Razorpay _razorpay = Razorpay();

  makePayment() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    double usdAmount = double.parse((widget.price).toString());
    int amtInCents = (usdAmount * 100).toInt();

    var options = {
      'key': 'rzp_test_YghCO1so2pwPnx',
      'amount': amtInCents,
      'name': 'Tech Basket',
      'currency': 'USD',
      'description': widget.name,
      'prefill': {'contact': phoneController.text, 'email': email},
    };

    _razorpay.open(options);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Details", style: SupportWidget.semiBoldTextStyle()),
        centerTitle: true,
        backgroundColor: Colors.green[200],
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_rounded),
        ),
      ),
      backgroundColor: SupportWidget.bgColor(),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //User Name
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: SupportWidget.adminTextFeildColor(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    enabled: false,
                    cursorColor: Colors.black54,
                    decoration: InputDecoration(
                      hintText: name,
                      hintStyle: SupportWidget.lightTextStyle(),
                      prefixIcon: Icon(Icons.person),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // User Email
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: SupportWidget.adminTextFeildColor(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    enabled: false,
                    cursorColor: Colors.black54,
                    decoration: InputDecoration(
                      hintText: email,
                      hintStyle: SupportWidget.lightTextStyle(),
                      prefixIcon: Icon(Icons.email_rounded),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // User Phone Number
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: SupportWidget.adminTextFeildColor(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: phoneController,
                    maxLength: 10,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Your Phone Number";
                      } else if (value.length < 10) {
                        return "Invalid Phone Number";
                      } else {
                        return null;
                      }
                    },
                    cursorColor: Colors.black54,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Enter Your Phone Number",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        height: 2,
                      ),
                      prefixIcon: Icon(Icons.phone),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 10),

                //User Address
                Container(
                  padding: EdgeInsets.only(left: 10, bottom: 6, right: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: SupportWidget.adminTextFeildColor(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: addressController,
                    cursorColor: Colors.black54,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Your Complete Address";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Enter Your Complete Address",
                      hintStyle: SupportWidget.lightTextStyle(),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Payment Btn
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: WidgetStatePropertyAll(2),
                    minimumSize: WidgetStatePropertyAll(Size(200, 40)),
                    backgroundColor: WidgetStatePropertyAll(Colors.red[300]),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool isOnline = await SupportWidget.hasInternet();

                      if (!isOnline) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(
                              child: Text(
                                "No internet connection!",
                                textScaler: TextScaler.linear(1.25),
                              ),
                            ),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return; // stop navigation
                      }
                      setState(() {
                        phoneNumber = phoneController.text;
                        address = addressController.text;
                      });
                      makePayment();
                    }
                  },
                  child: Text(
                    "Continue to Pay",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
