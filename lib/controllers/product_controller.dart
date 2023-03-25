import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../consts/consts.dart';
import '../service/category_model.dart';

class ProductController extends GetxController {
  var courseNameController = TextEditingController();
  var coursePriceController = TextEditingController();
  var courseDescribeController = TextEditingController();
  var isLoading = false.obs;
  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var subcat = [];
  var isFav = false.obs;
  var totalPrice = 0.obs;
//look into json file and get subcategories for each category
  updateCourse({course, price, describe, docId}) async {
    var store = firestore.collection(courseCollection).doc(docId);
    store.set({
      'c_name': course,
      'c_price': price,
      'c_desc': describe,
    }, SetOptions(merge: true));
    isLoading(false);
  }

  getSubCategories(title) async {
    subcat.clear();
    //store json string into data
    var data = await rootBundle.loadString("lib/service/category_model.json");
    //decode the data from json file
    var decoded = categoryModelFromJson(data);
    //decode the name into s var
    var s =
        decoded.categories.where((element) => element.name == title).toList();
    //store each subcategories data inside the category's name element
    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  getCourseCategories(title) async {
    subcat.clear();
    //store json string into data
    var data = await rootBundle.loadString("lib/service/course_model.json");
    //decode the data from json file
    var decoded = categoryModelFromJson(data);
    //decode the name into s var
    var s =
        decoded.categories.where((element) => element.name == title).toList();
    //store each subcategories data inside the category's name element
    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

//set the color to equal to index
  changeColorIndex(index) {
    colorIndex = index;
  }

//increase the qty by checking it's value contained
  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

//check if the value is still more than 0 then subtract by 1
  decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

//calculate a price by quantities
  calculateTotalPrice(price) {
    totalPrice.value = price * quantity.value;
  }

//set a collected data that will be stored inside a cartCollection
  addToCart({title, img, sellername, qty, tprice, context, vendorId}) async {
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      // 'appointment': date,
      'sellername': sellername,
      // 'color': color,
      'qty': qty,
      'vendor_id': vendorId,
      'tprice': tprice,
      'added_by': currentUser!.uid
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
  }

//a method that set some values to 0
  resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

//open product collection and look for p_wishlist field and union the value of currentUser
  addToWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to Wishlist");
  }

//open product collection and remove the array of p_wishlist from user current
  removeFromWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Removed from wishlist");
  }

//if current user id is in the p_wishlist make the isFav true or else is false
  checkIfFav(data) async {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }
}
