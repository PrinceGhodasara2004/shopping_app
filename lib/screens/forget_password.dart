import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String? email;

  String emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";

  TextEditingController emailController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  UserCredential? userCredential;

  forgetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      SupportWidget.showSnackBar(context, "Password reset email sent!");
    } on FirebaseAuthException catch (e) {
      if (e.code != userCredential) {
        SupportWidget.showSnackBar(context, "No User Found With this Email");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forget Password",
          style: SupportWidget.semiBoldTextStyle(),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_rounded),
        ),
        backgroundColor: Colors.green[200],
      ),
      backgroundColor: SupportWidget.bgColor(),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Text(
                  "Enter your email to get reset password link into your email.",
                  style: SupportWidget.lightTextStyle(),
                  textScaler: TextScaler.linear(1.25),
                ),

                SizedBox(height: 20),
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
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
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
                        forgetPassword();
                      }
                    },
                    child: Text(
                      "RESET PASSWORD",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
