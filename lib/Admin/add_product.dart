// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/services/databse.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  List<String> categoryItem = [
    "Headphone",
    "Laptop",
    "Smart Phone",
    "Smart Television",
    "Watch",
    "Airdopes",
    "Speakers",
    "Tablets",
    "Earphones",
    "Mouse",
  ];

  String? value;

  final ImagePicker _imagePicker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  uploadItem() async {
    setState(() {
      isLoading = true;
    });
    if (selectedImage != null &&
        nameController.text != "" &&
        priceController != "" &&
        detailController.text != "") {
      // String addId = randomAlphaNumeric(10);
      // Reference firebaseStorageRef = FirebaseStorage.instance
      //     .ref()
      //     .child("productImage")
      //     .child(addId);
      // final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      // var downloadUrl = await (await task).ref.getDownloadURL();

      Map<String, dynamic> addProduct = {
        "Name": nameController.text,
        "Price": priceController.text,
        "Details": detailController.text,
        "Image":
            "https://tse2.mm.bing.net/th?id=OIP.L3CNbsBGLO_klNC_SeCrpgHaIb&pid=Api&P=0&h=180",
      };

      await DatabseMethods().addProducts(addProduct, value!).then((
        value,
      ) async {
        await DatabseMethods().addAllProducts(addProduct);
        setState(() {
          selectedImage = null;
        });
        nameController.text = "";
        priceController.text = "";
        detailController.text = "";
        SupportWidget.showSnackBar(context, "Product Uploaded Successfully");
      });
    } else {
      SupportWidget.showSnackBar(context, "Please fill all the above details");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product", style: SupportWidget.semiBoldTextStyle()),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_outlined),
        ),
        backgroundColor: Colors.green[200],
      ),
      backgroundColor: SupportWidget.bgColor(),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Upload Product Image",
                      style: SupportWidget.lightTextStyle(),
                      textScaler: TextScaler.linear(1.25),
                    ),
                  ),

                  SizedBox(height: 10),

                  Center(
                    child:
                        selectedImage == null
                            ? GestureDetector(
                              onTap: () => getImage(),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black45,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: SupportWidget.adminTextFeildColor(),
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 30,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                            : Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black45,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: SupportWidget.adminTextFeildColor(),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                  ),

                  SizedBox(height: 30),

                  // Category Of the Products
                  Text(
                    "Product Category",
                    style: SupportWidget.lightTextStyle(),
                    textScaler: TextScaler.linear(1.25),
                  ),

                  SizedBox(height: 5),

                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: BoxDecoration(
                      color: SupportWidget.adminTextFeildColor(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items:
                            categoryItem
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: SupportWidget.lightTextStyle(),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) => setState(() {
                              this.value = value;
                            }),
                        value: value,
                        hint: Text(
                          "Select Product Category",
                          style: SupportWidget.lightTextStyle(),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Product Name
                  Text(
                    "Product Name",
                    style: SupportWidget.lightTextStyle(),
                    textScaler: TextScaler.linear(1.25),
                  ),

                  SizedBox(height: 5),

                  Container(
                    padding: EdgeInsets.only(left: 10, bottom: 6, right: 10),
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: SupportWidget.adminTextFeildColor(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: nameController,
                      cursorColor: Colors.black54,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Product Price
                  Text(
                    "Product Price",
                    style: SupportWidget.lightTextStyle(),
                    textScaler: TextScaler.linear(1.25),
                  ),

                  SizedBox(height: 5),

                  Container(
                    padding: EdgeInsets.only(left: 10, bottom: 6, right: 10),
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: SupportWidget.adminTextFeildColor(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      cursorColor: Colors.black54,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Product Details
                  Text(
                    "Product Details",
                    style: SupportWidget.lightTextStyle(),
                    textScaler: TextScaler.linear(1.25),
                  ),

                  SizedBox(height: 5),

                  Container(
                    padding: EdgeInsets.only(left: 10, bottom: 6, right: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: SupportWidget.adminTextFeildColor(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: detailController,
                      cursorColor: Colors.black54,
                      maxLines: 6,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),

                  SizedBox(height: 30),

                  // ADD Product Button
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: WidgetStatePropertyAll(2),
                        minimumSize: WidgetStatePropertyAll(Size(200, 40)),
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.green[200],
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        uploadItem();
                      },
                      child: Text(
                        "ADD PRODUCT",
                        style: TextStyle(color: Colors.black87, fontSize: 18),
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
}
