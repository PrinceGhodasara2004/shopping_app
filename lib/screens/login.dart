// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/bottomnav.dart';
import 'package:shopping_app/screens/forget_password.dart';
import 'package:shopping_app/screens/sign_up.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true, isLoading = false;
  String email = "", password = "";

  String emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SupportWidget.showSnackBar(context, "Login Successfully");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavScreen()),
      );
    } on FirebaseAuthException catch (e) {
      SupportWidget.showSnackBar(context, "Login failed: ${e.message}");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 40),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Image.asset("images/login.png", width: 300)),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "Login",
                        style: SupportWidget.boldTextStyle(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Email", style: SupportWidget.semiBoldTextStyle()),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your Email";
                        } else if (!RegExp(emailPattern).hasMatch(value)) {
                          return "Invalid Email Id";
                        } else {
                          return null;
                        }
                      },
                      cursorColor: Color.fromRGBO(28, 192, 169, 1),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        prefixIconColor: Color.fromRGBO(28, 192, 169, 1),
                        hintText: "Enter Email",
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
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your Password";
                        } else if (value.length < 6) {
                          return "Password Minimum Length Should be 6";
                        } else {
                          return null;
                        }
                      },
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
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ForgetPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Forget Password?",
                            style: SupportWidget.redclrText(),
                          ),
                        ),
                      ],
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
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                            });
                            userLogin();
                          }
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
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: SupportWidget.itemNameTextStyle(),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SignUpScreen()),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: SupportWidget.redclrText(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
}
