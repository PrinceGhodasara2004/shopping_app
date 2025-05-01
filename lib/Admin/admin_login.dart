// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/Admin/admin_home.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool _obscureText = true, isLoading = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset("images/login.png", width: 300)),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Admin Login Panel",
                      style: SupportWidget.boldTextStyle(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Username", style: SupportWidget.semiBoldTextStyle()),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: userNameController,
                    cursorColor: Color.fromRGBO(28, 192, 169, 1),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      prefixIconColor: Color.fromRGBO(28, 192, 169, 1),
                      hintText: "Enter Username",
                      hintStyle: SupportWidget.lightTextStyle(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(28, 192, 169, 1),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Text("Password", style: SupportWidget.semiBoldTextStyle()),

                  SizedBox(height: 5),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: userPasswordController,
                    cursorColor: Color.fromRGBO(28, 192, 169, 1),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      prefixIconColor: Color.fromRGBO(28, 192, 169, 1),
                      suffix: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child:
                            _obscureText
                                ? Icon(Icons.visibility_off)
                                : Icon(
                                  Icons.visibility,
                                  color: Color.fromRGBO(28, 192, 169, 1),
                                ),
                      ),
                      hintText: "Enter Password",
                      hintStyle: SupportWidget.lightTextStyle(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(28, 192, 169, 1),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size(150, 40)),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          Color.fromRGBO(28, 192, 169, 1),
                        ),
                      ),
                      onPressed: () {
                        Center(
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(28, 192, 169, 1),
                          ),
                        );
                        adminLogin();
                      },
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: CircularProgressIndicator(color: Colors.red[400]),
              ),
            ),
        ],
      ),
    );
  }

  adminLogin() {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance.collection("admin").get().then((snapshot) {
      for (var result in snapshot.docs) {
        if (result.data()['username'] != userNameController.text.trim()) {
          SupportWidget.showSnackBar(context, "Username is Incorrect");
        } else if (result.data()['password'] !=
            userPasswordController.text.trim()) {
          SupportWidget.showSnackBar(context, "Incorrect Password");
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AdminHomeScreen()),
          );
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }
}
