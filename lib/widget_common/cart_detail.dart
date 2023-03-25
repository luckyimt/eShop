import 'package:emart_app/auth_screen/Auth%20Screen/login_screen.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/splash_screen/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'our_button.dart';

//create exit widget with dialog showing confirmation box
Widget exitDialog(context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        //write confirm text and are you sure text.
        'confirm'.text.fontFamily(bold).size(18).color(darkFontGrey).make(),
        const Divider(),
        10.heightBox,
        "Are you sure want to exit?".text.size(16).color(darkFontGrey).make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //add yes button
            ourButton(
                color: redColor,
                onPress: () async {
                  SystemNavigator.pop();
                  await Get.put(AuthController()).signoutMethod(context);
                  Get.offAll(() => const SplashScreen());
                },
                textColor: whiteColor,
                title: "Yes"),
            //add no button
            ourButton(
              color: redColor,
              onPress: () {
                Navigator.pop(context);
              },
              textColor: whiteColor,
              title: "No",
            ),
          ],
        ),
      ],
    ).box.color(lightGrey).padding(const EdgeInsets.all(12)).rounded.make(),
  );
}
