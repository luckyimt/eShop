import 'package:emart_app/auth_screen/Auth Screen/signup_screen.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/widget_common/custom_textfield.dart';
import 'package:emart_app/widget_common/applogo_widget.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widget_common/our_button.dart';
import '../admin_home.dart';
import '../user_home.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.07).heightBox,
            //logo app
            applogoWidget(),
            //text under logo
            //Column of Textfield
            Obx(
              () => Column(
                children: [
                  //textfield for email
                  customTextField(
                      hint: emailHint,
                      title: email,
                      isPass: false,
                      controller: controller.emailController),
                  //textfield for password
                  customTextField(
                      hint: passwordHint,
                      title: password,
                      isPass: true,
                      controller: controller.passwordController),

                  // Align(
                  //     alignment: Alignment.centerRight,
                  //     child: TextButton(
                  //         onPressed: () {}, child: forgetPass.text.make())),
                  10.heightBox,
                  controller.isLoading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      //ปุ่มสำหรับ ล็อกอิน
                      : ourButton(
                          title: login,
                          onPress: () async {
                            // Get.to(() => const Home());
                            controller.isLoading(true);
                            await controller
                                .loginMethod(context: context)
                                .then((value) {
                              if (value != null) {
                                VxToast.show(context, msg: loggedin);
                                Get.offAll(() => const Home());
                              } else {
                                controller.isLoading(false);
                              }
                            });
                          },
                        ).box.width(context.screenWidth - 50).make(),
                  10.heightBox,
                  createNewAccount.text.color(Colors.pinkAccent).make(),
                  10.heightBox,
                  //ปุ่มสำหรับ สมัครสมาชิกใหม่
                  ourButton(
                      title: signup,
                      onPress: () {
                        Get.to(() => const SignupScreen());
                      }),
                  10.heightBox,
                  loginWith.text.color(Colors.pinkAccent).make(),
                  5.heightBox,
                  //ปุ่มสำหรับ admin login
                  ourButton(
                      title: "Admin Login ",
                      onPress: () async {
                        controller.isLoading(true);
                        await controller
                            .adminloginMethod(context: context)
                            .then((value) {
                          if (value != null) {
                            VxToast.show(context, msg: loggedin);
                            Get.offAll(() => const AdminHome());
                          } else {
                            controller.isLoading(false);
                          }
                        });
                      }),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: List.generate(
                  //       3,
                  //       (index) => Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: CircleAvatar(
                  //               child: Image.asset(
                  //                 socialIconList[index],
                  //                 width: 30,
                  //               ),
                  //             ),
                  //           )),
                  // )
                ],
              )
                  .box
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .make(),
            ),
          ],
        ),
      ),
    );
  }
}
