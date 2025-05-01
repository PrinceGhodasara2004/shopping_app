import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/screens/sign_up.dart';
import 'package:shopping_app/services/auth.dart';
import 'package:shopping_app/services/shared_pref.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? image, name, email;

  getUserDetailsSP() async {
    image = await SharedPreferenceHelper().getUserImage();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserDetailsSP();
  }

  final ImagePicker _imagePicker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    uploadItem();
    setState(() {});
  }

  uploadItem() async {
    if (selectedImage != null) {
      // String addId = randomAlphaNumeric(10);
      // Reference firebaseStorageRef = FirebaseStorage.instance
      //     .ref()
      //     .child("productImage")
      //     .child(addId);
      // final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      // var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferenceHelper().saveUserImage(
        "https://img.freepik.com/free-photo/bohemian-man-with-his-arms-crossed_1368-3542.jpg?ga=GA1.1.2146353693.1721885279&semt=ais_hybrid&w=740",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile", style: SupportWidget.semiBoldTextStyle()),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      backgroundColor: SupportWidget.bgColor(),
      body:
          name == null
              ? Center(child: CircularProgressIndicator())
              : Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    selectedImage != null
                        ? GestureDetector(
                          onTap: () => getImage(),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.file(
                                selectedImage!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                        : GestureDetector(
                          onTap: () => getImage(),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                image!,
                                height: 100,
                                width: 100,
                              ),
                            ),
                          ),
                        ),

                    SizedBox(height: 30),
                    Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 4,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: SupportWidget.lightTextStyle(),
                                  textScaler: TextScaler.linear(1.2),
                                ),
                                Text(
                                  name!,
                                  style: SupportWidget.semiBoldTextStyle(),
                                  textScaler: TextScaler.linear(0.90),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 4,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.email_rounded),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: SupportWidget.lightTextStyle(),
                                  textScaler: TextScaler.linear(1.2),
                                ),
                                Text(
                                  email!,
                                  style: SupportWidget.semiBoldTextStyle(),
                                  textScaler: TextScaler.linear(0.90),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              backgroundColor: SupportWidget.bgColor(),
                              icon: Image.asset(
                                "images/logout.png",
                                width: 30,
                                height: 30,
                              ),
                              title: Text("Logout"),
                              content: Text(
                                "Are You Sure U Want to Logout!!!",
                                style: TextStyle(fontSize: 18),
                              ),
                              actions: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    backgroundColor: WidgetStatePropertyAll(
                                      Colors.red[300],
                                    ),
                                  ),
                                  onPressed: () async {
                                    Center(child: CircularProgressIndicator());
                                    await AuthMethods().logOut().then((value) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SignUpScreen(),
                                        ),
                                      );
                                    });
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),

                                ElevatedButton(
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    backgroundColor: WidgetStatePropertyAll(
                                      Colors.red[300],
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.login_rounded),
                              SizedBox(width: 10),
                              Text(
                                "Logout",
                                style: SupportWidget.semiBoldTextStyle(),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
