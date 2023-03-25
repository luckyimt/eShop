import 'package:emart_app/consts/consts.dart';
import 'package:get/get.dart';
import '../../widget_common/applogo_widget.dart';
import '../../widget_common/custom_textfield.dart';
import '../../widget_common/our_button.dart';
import '../../controllers/auth_controller.dart';
import '../user_home.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

//text controller
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            Obx(
              () => Column(
                children: [
                  customTextField(
                      hint: nameHint,
                      title: name,
                      controller: nameController,
                      isPass: false),
                  customTextField(
                      hint: emailHint,
                      title: email,
                      controller: emailController,
                      isPass: false),
                  customTextField(
                      hint: passwordHint,
                      title: password,
                      controller: passwordController,
                      isPass: true),
                  customTextField(
                      hint: passwordHint,
                      title: retypePassword,
                      controller: passwordRetypeController,
                      isPass: true),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {}, child: forgetPass.text.make())),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.red,
                        checkColor: Colors.white,
                        value: isCheck,
                        onChanged: (newValue) {
                          setState(() {
                            isCheck = newValue;
                          });
                        },
                      ),
                      Expanded(
                        child: RichText(
                            text: const TextSpan(
                          children: [
                            TextSpan(
                                text: " I agree to the ",
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,
                                )),
                            TextSpan(
                                text: " & ",
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,
                                )),
                            TextSpan(
                                text: termAndCond,
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: redColor,
                                )),
                            TextSpan(
                                text: privacyPolicy,
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: redColor,
                                )),
                          ],
                        )),
                      ),
                    ],
                  ),
                  //signup button
                  controller.isLoading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      : ourButton(
                          color: isCheck == true ? redColor : lightGrey,
                          title: signup,
                          textColor: whiteColor,
                          onPress: () async {
                            if (isCheck == true) {
                              try {
                                VxToast.show(context,
                                    msg: "signed up successfully");
                                Get.offAll(() => const Home());
                                // await controller
                                //     .signupMethod(
                                //         email: emailController.text,
                                //         password: passwordController.text,
                                //         context: context)
                                //     .then((value) {
                                //   return controller.storeUserData(
                                //       email: emailController.text,
                                //       password: passwordController.text,
                                //       name: nameController.text);
                                // }).then((value) {
                                //   VxToast.show(context,
                                //       msg: "signed up successfully");
                                //   Get.offAll(() => const Home());
                                // });
                              } catch (e) {
                                // auth.signOut();
                                VxToast.show(context, msg: e.toString());
                              }
                            }
                          }).box.width(context.screenWidth - 50).make(),
                  // RichText(
                  //   text: const TextSpan(
                  //     children: [
                  //       TextSpan(
                  //           text: alreadyHaveAccount,
                  //           style: TextStyle(fontFamily: bold, color: fontGrey)),
                  //       TextSpan(
                  //           text: login,
                  //           style: TextStyle(fontFamily: bold, color: redColor))
                  //     ],
                  //   ),
                  // ).onTap(() {
                  //   Get.back();
                  // })
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadow
                  .make(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                alreadyHaveAccount.text.color(fontGrey).make(),
                login.text.color(redColor).make().onTap(() {
                  Get.back();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
