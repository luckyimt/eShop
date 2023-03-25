import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/widget_common/our_button.dart';
import '/controllers/profile_controller.dart';
import '/widget_common/custom_textfield.dart';
import 'package:get/get.dart';
import 'dart:io';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;
  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    //create inside bgWidget
    //with scaffold and appbar added
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.pinkAccent, Colors.white])),
      child: Scaffold(
        backgroundColor: Colors.pink.shade100,
        appBar: AppBar(
          title: const Text("edit Account"),
          backgroundColor: Colors.pink.shade200,
        ),
        //create obx body inside is a column of page details
        body: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //if data image url and controller path is empty show image2
              data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                  ? Image.asset(imgProfile2, width: 100, fit: BoxFit.cover)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make()
                  //if data is not empty but controller path is empty show image form network
                  : data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                      ? Image.network(
                          data['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()
                      //else if controller path is not empty but data image is empty get image from a file
                      : Image.file(
                          File(controller.profileImgPath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              //add change image button with the 'change' label
              ourButton(
                  color: redColor,
                  onPress: () {
                    controller.changeImage(context);
                  },
                  textColor: whiteColor,
                  title: "change"),
              const Divider(),
              20.heightBox,
              //create text input field of name new password and old password
              customTextField(
                  controller: controller.nameController,
                  hint: nameHint,
                  title: name,
                  isPass: false),
              customTextField(
                  hint: "Telephone Number",
                  isPass: false,
                  title: "Phone Number",
                  controller: controller.phoneController),
              customTextField(
                  controller: controller.newpassController,
                  hint: passwordHint,
                  title: newpass,
                  isPass: true),
              customTextField(
                  controller: controller.oldpassController,
                  hint: passwordHint,
                  title: oldpass,
                  isPass: true),
              20.heightBox,
              //show loading indicator before display profile image
              controller.isLoading.value
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    )
                  : SizedBox(
                      width: context.screenWidth - 60,
                      //show button image from img path of the profile
                      child: ourButton(
                          color: redColor,
                          onPress: () async {
                            controller.isLoading(true);
                            //if image is not selected
                            if (controller.profileImgPath.value.isNotEmpty) {
                              await controller.uploadProfileImage();
                            } else {
                              controller.profileImageLink = data['imageUrl'];
                            }
                            //if old password match database then get email address and passwords
                            //to update the old password
                            if (data['password'] ==
                                controller.oldpassController.text) {
                              controller.changeAuthPassword(
                                email: data['email'],
                                password: controller.oldpassController.text,
                                newpassword: controller.newpassController.text,
                              );
                              await controller.updateProfile(
                                  imgUrl: controller.profileImageLink,
                                  name: controller.nameController.text,
                                  password: controller.newpassController.text,
                                  phone: controller.phoneController.text);
                              //then show a 'updated' text
                              VxToast.show(context,
                                  msg: "บันทึกการแก้ไขแล้วค่ะ");
                            } else {
                              //if password doest correct show 'Wrong old password'
                              VxToast.show(context,
                                  msg: "รหัสผ่านไม่ยังถูกต้องนะคะ");
                              controller.isLoading(false);
                            }
                          },
                          textColor: whiteColor,
                          title: "save"),
                    ),
            ],
          )
              .box
              .white
              .shadowSm
              .padding(const EdgeInsets.all(16))
              .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
              .rounded
              .make(),
        ),
      ),
    );
  }
}
