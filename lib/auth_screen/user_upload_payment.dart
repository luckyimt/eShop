import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import '../controllers/cart_controller.dart';
import '../controllers/home_controller.dart';
import '../snackbar.dart';
import 'user_home.dart';
import 'package:get/get.dart';

class UploadPayment extends StatefulWidget {
  final String today;
  final String time;
  final dynamic data;
  final String? totalPrice;
  const UploadPayment(
      {Key? key,
      this.data,
      this.totalPrice,
      required this.today,
      required this.time})
      : super(key: key);

  @override
  State<UploadPayment> createState() => _UploadPaymentState();
}

class _UploadPaymentState extends State<UploadPayment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  bool processing = false;
  final ImagePicker _picker = ImagePicker();
  // var secretKey;

  List<XFile> imageFileList = [];
  List<String> imageUrlList = [];
  dynamic _pickedImageError;

  void pickProductImage() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 100);
      setState(() {
        imageFileList = pickedImages!;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Widget previewImages() {
    if (imageFileList!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(0),
        child: ListView.builder(
            itemCount: imageFileList!.length,
            itemBuilder: (context, index) {
              return Image.file(
                File(imageFileList[index].path),
                fit: BoxFit.cover,
              );
            }),
      );
    } else {
      return const Center(
        child: Text('choose an image',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white)),
      );
    }
  }

  Future<void> uploadImage() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imageFileList!.isNotEmpty) {
        setState(() {
          processing = true;
        });
        try {
          for (var image in imageFileList!) {
            firebase_storage.Reference ref = firebase_storage
                .FirebaseStorage.instance
                .ref('products/${path.basename(image.path)}');
            await ref.putFile(File(image.path)).whenComplete(() async {
              await ref.getDownloadURL().then((value) {
                imageUrlList.add(value);
              });
            });
          }
        } catch (e) {
          print(e);
        }
        //directory in firebase

      } else {
        MyMessageHandler.showSnackBar(_scaffoldKey, 'please pick image first');
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all field');
    }
  }

  void uploaddata(docId, context) async {
    //see if image is not empty then connect to products and upload to it's folder
    if (imageUrlList.isNotEmpty) {
      CollectionReference productRef =
          FirebaseFirestore.instance.collection('Payment');
//list of detail within products
      await productRef.doc().set({
        'id': currentUser!.uid,
        'name': Get.find<HomeController>().username,
        // 'key': secretKey,
        'paid_imgs': imageUrlList,
        'date': widget.today,
        'time': widget.time,
        'total': widget.totalPrice,
        //when complete uploading clear the data fields.
      }).whenComplete(() => setState(() {
            processing = false;
            imageFileList = [];
            // subCategList = [];
            imageUrlList = [];
          }));
      //reset screen
      _formKey.currentState!.reset();
      Get.offAll(() => const Home());
    }

    //if no image selected print no image
    else {
      print('no image');
    }
  }

//connect to uploaddata then wait for complete
  void uploadSlip(docId, context) async {
    await uploadImage().whenComplete(() => uploaddata(docId, context));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //create scaffold for messenger handler
    return ScaffoldMessenger(
        //create a scaffold
        child: Scaffold(
      appBar: AppBar(
        title: "ชำระเงิน".text.wider.color(Colors.white).make(),
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
      ), //conduct the key for scaffold
      key: _scaffoldKey,
      //create safe area
      body: SafeArea(
        //eneble scrollable screen
        child: SingleChildScrollView(
          //set to reversable to scroll up and down then push the field with in
          reverse: true,
          //put aside the keyboard when unactive
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            //create column with stretching horizontally alignment
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Container(
                    height: size.height * 0.40,
                    child: imageFileList != null
                        //if not null then call preview image
                        ? previewImages()
                        //else print warning text box
                        : const Center(
                            child: Text('you have not\n\n pick image yet !',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16)),
                          ),
                  ),
                  Row(
                    children: [
                      "฿".text.white.make(),
                      "Total Price".text.white.size(16).make(),
                    ],
                  ),
                  widget.totalPrice
                      .toString()
                      .numCurrency
                      .text
                      .white
                      .size(22)
                      .make(),
                  const Divider(color: Colors.grey, height: 40),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(side: const BorderSide()),
                    onPressed: imageFileList!.isEmpty
                        ? () {
                            pickProductImage();
                          }
                        : () {
                            setState(() {
                              imageFileList = [];
                            });
                          },
                    child:
                        "เพิ่มรูปภาพ".text.size(16).color(Colors.pink).make(),
                  ).box.make(),
                  //create part that accept product name
                  // child: TextFormField(
                  //     validator: (value) {
                  //       if (value!.isEmpty) {
                  //         return 'เลขรายการ3ตัวท้าย';
                  //       }
                  //       return null;
                  //     },
                  //     onChanged: (value) {
                  //       secretKey = value;
                  //     },
                  //     decoration: textFormDecoration.copyWith(
                  //       labelText: 'ดูที่ใบเสร็จ',
                  //     )),
                  10.heightBox,
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(side: const BorderSide()),
                    onPressed: processing == true
                        ? null
                        : () {
                            uploadSlip("", context);
                          },
                    child: "อัพโหลด".text.size(18).color(Colors.pink).make(),
                  ).box.make(),
                  20.heightBox,
                  "สแกน QR code แล้วอัพโหลดสลิปใบเสร็จ \nตรวจสอบคำสั่งซื้อของคุณ ไปที่ 'บัญชี' \n ขอแสดงความขอบคุณด้วยค่ะ"
                      .text
                      .white
                      .size(14)
                      .make()
                      .box
                      .padding(EdgeInsets.all(20))
                      .rounded
                      .pink500
                      .make(),
                  20.heightBox,
                  Image.asset(qrcode)
                      .box
                      .white
                      .size(300, 300)
                      .padding(const EdgeInsets.all(0))
                      .rounded
                      .make(),
                ])
                .box
                .roundedLg
                .shadowLg
                .color(Colors.grey.shade900)
                .padding(EdgeInsets.all(30))
                .make(),
          ),
        ),
      ),
    ));
  }
}
