import '../consts/firebase_consts.dart';

//get user collection
// where user id is id of <uid>
class FirestoreServices {
  static getUser(uid) {
    return firestore
        .collection(userCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  //get product from collection
  // on firebase where the value
  // is specified to <category>
  static getProducts(category) {
    return firestore
        .collection(productsCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }

  static getCourse(category) {
    return firestore
        .collection(courseCollection)
        .where('c_category', isEqualTo: category)
        .snapshots();
  }

  //get into cart collection
  // where userid is equal to
  // parameter <uid>
  static getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  static getAllPayment() {
    return firestore
        .collection(paymentsCollection)
        .where('id', isNotEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getAllCourses() {
    return firestore
        .collection(courseCollection)
        .where('vendor_id', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  //delete cart item which document id
  // is equal to parameter <docId>
  static deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  static deleteCourse(docId) {
    return firestore.collection(courseCollection).doc(docId).delete();
  }

  static deleteOrder(docId) {
    return firestore.collection(ordersCollection).doc(docId).delete();
  }

  static deleteSlip(docId) {
    return firestore.collection(paymentsCollection).doc(docId).delete();
  }

  //get messages from chat collection
  // and message collection which document id
  // is equal to <docId>
  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  static getCourseName() {
    return firestore.collection(ordersCollection).where('orders').snapshots();
  }

  static getOrderSlip() {
    return firestore
        .collection(paymentsCollection)
        .where('id', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getAllOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getAdminOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_by', isNotEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getWishlists() {
    return firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getAllMessages() {
    return firestore
        .collection(chatsCollection)
        .where('fromid', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getCounts() async {
    var res = await Future.wait([
      firestore
          .collection(cartCollection)
          .where('added_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        // if (value.docs.isNotEmpty) {
        //   print(value.docs.length);
        // }
        return value.docs.length;
      }),
      firestore
          .collection(productsCollection)
          .where('p_wishlist', arrayContains: currentUser!.uid)
          .get()
          .then((value) {
        // if (value.docs.isNotEmpty) {
        //   print(value.docs.length);
        // }
        return value.docs.length;
      }),
      firestore
          .collection(ordersCollection)
          .where('order_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        // if (value.docs.isNotEmpty) {
        //   print(value.docs.length);
        // }
        return value.docs.length;
      }),
    ]);
    return res;
  }

  static allproducts() {
    return firestore.collection(productsCollection).snapshots();
  }

  static allcourse() {
    return firestore.collection(courseCollection).snapshots();
  }

  static getFeaturedProducts() {
    return firestore
        .collection(productsCollection)
        .where('is_Featured', isEqualTo: true)
        .get();
  }

  static getOrderStatus() {
    return firestore
        .collection(ordersCollection)
        .where('order_confirmed', isEqualTo: true)
        .snapshots();
  }
}
