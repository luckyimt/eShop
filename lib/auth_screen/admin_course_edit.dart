import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/widget_common/our_button.dart';
import '../controllers/product_controller.dart';
import '../service/firestore_services.dart';
import '/widget_common/custom_textfield.dart';
import 'package:get/get.dart';

class EditCourseScreen extends StatelessWidget {
  final dynamic data;
  const EditCourseScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    //create inside bgWidget
    //with scaffold and appbar added
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.pinkAccent, Colors.white])),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("แก้ไข ลบ คอร์ส"),
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
        //create obx body inside is a column of page details
        body: Obx(
          () => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                20.heightBox,
                //create text input field of name new password and old password
                customTextField(
                    controller: controller.courseNameController,
                    hint: "ป้อนชื่อ",
                    title: "ชื่อคอร์ส",
                    isPass: false),
                customTextField(
                    hint: "กำหนดราคา",
                    isPass: false,
                    title: "ราคาคอร์ส",
                    controller: controller.coursePriceController),
                customTextField(
                    controller: controller.courseDescribeController,
                    hint: "คำอธิบาย",
                    title: "คำอธิบาย",
                    isPass: false),
                20.heightBox,
                //show loading indicator before display profile image
                controller.isLoading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      )
                    : SizedBox(
                        width: context.screenWidth - 60,
                        child: ourButton(
                            color: redColor,
                            onPress: () {
                              if ((controller
                                          .courseNameController.text ==
                                      "") ||
                                  (controller
                                      .courseNameController.text.isNum) ||
                                  (controller.coursePriceController.text
                                      .isLetter()) ||
                                  (controller.coursePriceController.text ==
                                      "")) {
                                VxToast.show(context,
                                    msg: "ป้อนข้อมูลให้ครบถ้วนด้วยค่ะ");
                              } else {
                                controller.updateCourse(
                                  course: controller.courseNameController.text,
                                  price: controller.coursePriceController.text,
                                  describe:
                                      controller.courseDescribeController.text,
                                  docId: data.id,
                                );
                                Get.back();
                                // controller.isLoading(true);
                                // }
                              }
                            },
                            textColor: whiteColor,
                            title: "บันทึก"),
                      ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "ข้อมูลสินค้า"
                              .text
                              .size(18)
                              .color(Colors.white)
                              .wider
                              .make(),
                          const Divider(),
                          "คอร์ส: ${data['c_name']}"
                              .text
                              .size(16)
                              .color(Colors.white)
                              .wider
                              .make(),
                          "ราคา: ${data['c_price']}"
                              .text
                              .size(16)
                              .color(Colors.white)
                              .wider
                              .make(),
                          const Divider(),
                          "คำอธิบาย: ${data['c_desc']}"
                              .text
                              .size(16)
                              .color(Colors.white)
                              .wider
                              .make(),
                          10.heightBox,
                          const Divider(),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () async {
                              FirestoreServices.deleteCourse(data.id);
                              Get.back();
                            },
                            child: const Text("ลบรายการ")),
                      ],
                    ),
                  ],
                ),
              ],
            )
                .box
                .gray900
                .shadowLg
                .padding(const EdgeInsets.all(16))
                .rounded
                .make(),
          ),
        ),
      ),
    );
  }
}
