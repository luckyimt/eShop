import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../consts/consts.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  Future<UserCredential?> loginMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      // if there is an error the program
      // catch error and print it
      VxToast.show(context, msg: e.toString());
    }
    //return userCredential for user identifier
    return userCredential;
  }

  Future<UserCredential?> adminloginMethod({email, password, context}) async {
    UserCredential? userCredential;
    // wait the for user to give
    // email password authentication
    // by  signInWithEmailAndPassword
    if ((emailController.text == "adminm@mail.com") &&
        (passwordController.text == "123456")) {
      try {
        userCredential = await auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } on FirebaseAuthException catch (e) {
        // if there is an error the program
        // catch error and print it
        VxToast.show(context, msg: e.toString());
      }

      //return userCredential for user identifier
      return userCredential;
    } else
      VxToast.show(context, msg: "ข้อมูลไม่ถูกต้องนะคะ");
  }

  //create user with email and password method
  //future class can be asynchronous meaning it
  // can wait for other process computation
  // without stop to program use can type all
  // field before pressing ok once

  //the method wait for user to give all sign up data
  //
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      //email given will be validation also the password
      userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  storeUserData({email, password, name}) async {
    DocumentReference store =
        await firestore.collection(userCollection).doc(currentUser!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'id': currentUser!.uid,
      'imageUrl': ""
    });
  }

  // Sign out Method
  // get context of the page and call signOut method
  // for an online user
  signoutMethod(context) async {
    try {
      return await FirebaseAuth.instance.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
