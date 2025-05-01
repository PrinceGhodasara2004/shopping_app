import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SupportWidget {
  static TextStyle boldTextStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    );
  }

  // Checks Connectivity
  static Future<bool> hasInternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) return false;

    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            msg,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(28, 192, 169, 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Color bgColor() {
    return Color.fromARGB(255, 225, 248, 220);
  }

  static Color adminTextFeildColor() {
    return Color.fromARGB(255, 195, 223, 187);
  }

  static TextStyle semiBoldTextStyle() {
    return TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  }

  static TextStyle itemNameTextStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
  }

  static TextStyle lightTextStyle() {
    return TextStyle(fontWeight: FontWeight.w500, color: Colors.black54);
  }

  static TextStyle redclrText() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.red[300],
    );
  }
}
