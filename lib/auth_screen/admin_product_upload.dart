import 'dart:io';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../categ.dart';
import '../snackbar.dart';
import 'admin_order_screen.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String productName;
  late String productDescription;
  late String proId;
  String mainCategValue = 'select category';
  // String subCategoryValue = 'subcategory';
  // List<String> subCategList = [];
  bool processing = false;
  final ImagePicker _picker = ImagePicker();

  List<XFile> imageFileList = [];
  List<String> imageUrlList = [];
  dynamic _pickedImageError;

  void pickProductImage() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 400, maxWidth: 300, imageQuality: 100);
      setState(() {
        imageFileList = pickedImages;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
    }
  }

  Widget previewImages() {
    if (imageFileList.isNotEmpty) {
      return ListView.builder(
          itemCount: imageFileList.length,
          itemBuilder: (context, index) {
            return Image.file(File(imageFileList[index].path));
          }).box.padding(const EdgeInsets.all(10)).white.shadowLg.make();
    } else {
      return const Center(
        child: Text('เพิ่มรูป',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.black)),
      );
    }
  }

  void selectedMainCateg(String? value) {
    setState(() {
      mainCategValue = value!;
    });
  }

  Future<void> uploadImage() async {
    if (mainCategValue != 'select category') {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imageFileList.isNotEmpty) {
          setState(() {
            processing = true;
          });
          try {
            for (var image in imageFileList) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('courses/${path.basename(image.path)}');
              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imageUrlList.add(value);
                });
              });
            }
          } catch (e) {
            MyMessageHandler.showSnackBar(_scaffoldKey, e.toString());
          }
          //directory in firebase

        } else {
          MyMessageHandler.showSnackBar(_scaffoldKey, 'กรุณาเลือกรูปภาพ');
        }
      } else {
        MyMessageHandler.showSnackBar(
            _scaffoldKey, 'กรุณาป้อนข้อมูลในทุกช่องด้วยคะ');
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'กรุณาเลือกประเภท');
    }
  }

  void uploadData() async {
    //see if image is not empty then connect to products and upload to it's folder
    if (imageUrlList.isNotEmpty) {
      CollectionReference productRef =
          FirebaseFirestore.instance.collection('courses');
      proId = const Uuid().v4();
//list of detail within products
      await productRef.doc().set({
        'c_category': mainCategValue,
        'c_price': price.toString(),
        'c_desc': productDescription,
        'c_name': productName,
        'vendor_id': FirebaseAuth.instance.currentUser!.uid,
        'p_wishlist': '',
        'c_quantity': "99",
        'c_imgs': imageUrlList,
        'c_rating': "5.0",
        'c_seller': "Civilize Clinic",
        // 'c_seller': Get.find<HomeController>().username,
        //when complete uploading clear the data fields.
      }).whenComplete(() => setState(() {
            processing = false;
            imageFileList = [];
            mainCategValue = 'select category';
            // subCategList = [];
            imageUrlList = [];
          }));
      //reset screen
      _formKey.currentState!.reset();
    }
    Get.to(() => const AdminHomeScreen());
    //if no image selected print no image
  }

//connect to upload data then wait for complete
  void uploadProduct() async {
    await uploadImage().whenComplete(() => uploadData());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //create scaffold for messenger handler
    return ScaffoldMessenger(
      //create a scaffold
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.pinkAccent, Colors.white])),
        child: Scaffold(
          appBar: AppBar(
            title: "เพิ่มคอร์ส".text.wider.make(),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.pinkAccent,
                      Colors.white,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
          ),
          //conduct the key for scaffold
          key: _scaffoldKey,
          //create safe area
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SafeArea(
              //eneble scrollable screen
              child: SingleChildScrollView(
                //set to reversable to scroll up and down then push the field with in
                reverse: true,
                //put aside the keyboard when unactive
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: _formKey,
                  //create column with stretching horizontally alignment
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Colors.pinkAccent, Colors.white])),
                          height: size.height * 0.315,
                          //ask if image list is empty
                          child: imageFileList != null
                              //if not null then call preview image
                              ? previewImages()
                              //else print warning text box
                              : const Center(
                                  child: Text('Please pick a course image.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.black)),
                                ),
                        ).box.shadowLg.roundedLg.make(),

                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //build a text form field says select main category
                                //add dropdown menu
                                DropdownButton(
                                    iconSize: 40,
                                    iconEnabledColor: Colors.pink,
                                    dropdownColor: Colors.pink.shade100,
                                    menuMaxHeight: 500,
                                    value: mainCategValue,
                                    //add items call categ with mapping String value
                                    items: categ
                                        .map<DropdownMenuItem<String>>((value) {
                                      //show the dropdown menu
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ); //cange to list and create a selection category part
                                    }).toList(),
                                    onChanged: (String? value) {
                                      selectedMainCateg(value);
                                    }),
                              ],
                            ),
                          ],
                        ),
                        //see if image list is not empty then proceed to clear all images in a list
                        5.heightBox,
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.9,
                          //create text field to insert price.
                          child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter price';
                                } else if (value.isValidPrice() != true) {
                                  return 'Invalid price';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                price = double.parse(value);
                              },
                              // keyboardType:
                              //     //set keyboard to number style and label with a text
                              //     const TextInputType.numberWithOptions(
                              //         decimal: true),
                              decoration: textFormDecoration.copyWith(
                                labelText: 'ราคา',
                              )),
                        ),
                        10.heightBox,
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.45,
                          //create part that accept product name
                          child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter product name';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                productName = value;
                              },
                              decoration: textFormDecoration.copyWith(
                                labelText: 'ชื่อคอร์ส',
                              )),
                        ),
                        10.heightBox,
                        SizedBox(
                          height: 180,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Product Description';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                productDescription = value;
                              },
                              maxLength: 800,
                              maxLines: 2,
                              decoration: textFormDecoration.copyWith(
                                labelText: 'คำอธิบายคอร์ส',
                              )),
                        ),
                      ]),
                ),
              ),
            ),
          ),

          floatingActionButton:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            FloatingActionButton(
                onPressed: imageFileList.isEmpty
                    ? () {
                        pickProductImage();
                      }
                    : () {
                        setState(() {
                          imageFileList = [];
                        });
                      },
                backgroundColor: Colors.white,
                child: imageFileList.isEmpty
                    ? const Icon(Icons.photo_library, color: Colors.pinkAccent)
                    : const Icon(Icons.delete_forever,
                        color: Colors.pinkAccent)),
            FloatingActionButton(
              onPressed: processing == true
                  ? null
                  : () {
                      uploadProduct();
                    },
              backgroundColor: Colors.white,
              child: processing == true
                  ? const CircularProgressIndicator(
                      color: Colors.black,
                    )
                  : const Icon(Icons.upload, color: Colors.pinkAccent),
            ),
          ]),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelStyle: const TextStyle(color: Colors.black),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 1),
      borderRadius: BorderRadius.circular(10)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 1),
      borderRadius: BorderRadius.circular(10)),
);

//checking for valid quantity
//and extension that check the format of input
extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

//checking for valid price
//checking price insert that is allow to use
extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}
