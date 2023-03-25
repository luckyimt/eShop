import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/controllers/home_controller.dart';
import 'package:get/get.dart';

import '../consts/consts.dart';

class CartController extends GetxController {
  var totalP = 0.obs;
  //text controller for shipping details
  //address , city , state , postalcode , phone
  var phoneController = TextEditingController();
  DateTime date = DateTime.now();
  late dynamic productSnapshot;
  // create a list to store products
  var products = [];
  // create index for each payment type
  var paymentIndex = 0.obs;
  var placingOrder = false.obs;

  //create calculate method with data of 'tprice' as parameter
  //get data of 'tprice' sum them up and store in totalP
  //totalP is the total price of all item in user cart
  calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  // use the index number as
  // type of paymentIndex
  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  //create placeMyOrder method to write
  // data to ordersCollection
  // use orderPaymentMethod and totalAmount as
  // data to write the billing data
  // to all these field

  placeMyOrder({
    // required orderPaymentMethod,
    required totalAmount,
    time,
    date,
  }) async {
    placingOrder(true);
    if (totalAmount != 0) {
      await getProductDetails();
      await firestore.collection(ordersCollection).doc().set({
        'order_date': FieldValue.serverTimestamp(),
        'order_by': currentUser!.uid,
        'order_by_username': Get.find<HomeController>().username,
        'order_by_email': currentUser!.email,
        'order_by_phone': phoneController.text,
        // 'line': lineController.text,
        'appointment': date,
        'tickets': '5',
        // 'shipping_method': "Home Delivery",
        // 'payment_method': orderPaymentMethod,
        'slip_verify': false,
        'postSlip_Done': false,
        'total_amount': totalAmount,
        'orders': FieldValue.arrayUnion(products),
        'time': time,
      });
      placingOrder(false);
    } else {
      print("no cart item");
    }
  }

  // create getProductsDetails
  // set the field that will be written
  // when call the method
  getProductDetails() {
    products.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'tprice': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
      });
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }

  final firestoreInstance = FirebaseFirestore.instance;

  postSlipDone(docId, context) async {
    var store = firestoreInstance.collection(ordersCollection).doc(docId);
    store.update({
      "postSlip_Done": true,
    });
  }

  confirmed(docId, context) async {
    var store = firestoreInstance.collection(ordersCollection).doc(docId);
    store.update(
      {
        "slip_verify": true,
      },
    );
  }

  unconfirmed(docId, context) async {
    var store = firestoreInstance.collection(ordersCollection).doc(docId);

    store.update(
      {
        "order_confirmed": false,
      },
    );
  }
}
