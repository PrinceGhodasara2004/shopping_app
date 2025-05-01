// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously, unused_local_variable, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:shopping_app/screens/bottomnav.dart';
import 'package:shopping_app/screens/login.dart';
import 'package:shopping_app/services/databse.dart';
import 'package:shopping_app/services/shared_pref.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscureText = true, isLoading = false;
  String? name, email, password;

  String emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    setState(() {
      isLoading = true;
    });
    if (password != null && name != null && email != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);

        SupportWidget.showSnackBar(context, "Registered Successfully");

        String Id = randomAlphaNumeric(10);

        // Saving Data Locally

        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserName(nameController.text);
        await SharedPreferenceHelper().saveUserEmail(emailController.text);
        await SharedPreferenceHelper().saveUserImage(
          "https://img.freepik.com/free-photo/bohemian-man-with-his-arms-crossed_1368-3542.jpg?ga=GA1.1.2146353693.1721885279&semt=ais_hybrid&w=740",
        );

        // Sending Data to Firebase Database

        Map<String, dynamic> userInfoMap = {
          "Name": nameController.text,
          "Email": emailController.text,
          "Password": passwordController.text,
          "Id": Id,
          "Image":
              "https://img.freepik.com/free-photo/bohemian-man-with-his-arms-crossed_1368-3542.jpg?ga=GA1.1.2146353693.1721885279&semt=ais_hybrid&w=740",
        };

        await DatabseMethods().addUserDetails(userInfoMap, Id);

        Center(child: CircularProgressIndicator(color: Colors.amber));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BottomNavScreen()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          SupportWidget.showSnackBar(context, "Password Provided is to Weak");
        } else if (e.code == 'email-already-in-use') {
          SupportWidget.showSnackBar(context, "Account Already Exists");
        }
      }
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
                        "Sign up",
                        style: SupportWidget.boldTextStyle(),
                      ),
                    ),

                    // Name
                    SizedBox(height: 20),
                    Text("Name", style: SupportWidget.semiBoldTextStyle()),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your Name";
                        } else {
                          return null;
                        }
                      },
                      cursorColor: Color.fromRGBO(28, 192, 169, 1),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        prefixIconColor: Color.fromRGBO(28, 192, 169, 1),
                        hintText: "Enter Your Name",
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

                    // Email
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

                    // Password
                    SizedBox(height: 20),
                    Text("Password", style: SupportWidget.semiBoldTextStyle()),

                    SizedBox(height: 5),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscureText,
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

                    // Sign up btn
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
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              name = nameController.text;
                              email = emailController.text;
                              password = passwordController.text;
                            });
                          }
                          registration();
                        },
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    // Already account txt
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: SupportWidget.itemNameTextStyle(),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "Sign In",
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
