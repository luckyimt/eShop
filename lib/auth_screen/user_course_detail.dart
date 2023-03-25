import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/cart_controller.dart';
import 'package:emart_app/controllers/product_controller.dart';
import 'package:get/get.dart';
import '../chat_screen/chat_screen.dart';
import '../widget_common/our_button.dart';

class CourseDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const CourseDetails({Key? key, required this.title, this.data})
      : super(key: key);

  // DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var cartController = Get.put(CartController());
    var controller = Get.put(ProductController());
    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.pinkAccent, Colors.white])),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                controller.resetValues();
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
                size: 25,
                color: Colors.white,
              ),
            ),
            title: title!.text.white.make(),
            actions: [
              // IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.ios_share_rounded,
              //     )),

              Obx(
                () => IconButton(
                    onPressed: () {
                      //use this data.id to call removeFromWishlist and addToWishlist
                      if (controller.isFav.value) {
                        controller.removeFromWishlist(data.id, context);
                        controller.isFav(false);
                      } else {
                        controller.addToWishlist(data.id, context);
                        controller.isFav(true);
                      }
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: controller.isFav.value
                          ? Colors.green.shade400
                          : Colors.pink.shade50,
                      size: 25,
                    )),
              ),
            ],
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
          body: Column(
            children: [
              10.heightBox,

              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      //widget Vx Swiper builder
                      Container(
                        child: VxSwiper.builder(
                            viewportFraction: 1.0,
                            enlargeCenterPage: true,
                            itemCount: data['c_imgs'].length,
                            itemBuilder: (context, index) {
                              //Get image from network display them in fullscreen mode
                              return Image.network(
                                //แสดงภาพสินค้าทีละภาพจากดาต้าเบส
                                data['c_imgs'][index],
                                //กำหนดความกว้างและกำหนดให้ขนาดพอดีกับความกว้างจอ
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              );
                            }),
                      ),
                      const Divider(
                        height: 30,
                        thickness: 2,
                        color: Colors.green,
                      ),
                      //เขียนข้อความชนิด title จากดาต้าเบส
                      title!.text.size(16).color(Colors.black).wider.make(),
                      VxRating(
                          isSelectable: true,
                          value: double.parse(data['c_rating']),
                          onRatingUpdate: (value) {
                            value;
                          },
                          //กำหนดลักษณะ
                          normalColor: textfieldGrey,
                          selectionColor: Colors.orangeAccent,
                          count: 5,
                          maxRating: 5,
                          size: 20,
                          stepInt: true),
                      //product price section
                      //เขียนราคา p_price จากดาต้าเบส ในรูปแบบราคาสินค้า
                      Row(
                        children: [
                          "฿".text.white.make(),
                          "${data['c_price']}"
                              .numCurrency
                              //ลักษณะ
                              .text
                              .white
                              .fontFamily(semibold)
                              .size(26)
                              .wider
                              .make(),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )),
                          //send message section
                          //create Icon on click to get to chat screen with green color
                          const CircleAvatar(
                            backgroundColor: Colors.pink,
                            child: Icon(Icons.message_outlined,
                                color: Colors.white),
                          ).onTap(() {
                            Get.to(
                              //call a  chat screen message icon on pressed
                              () => const ChatScreen(),
                              //set seller and vendor
                              arguments: [data['c_seller'], data['vendor_id']],
                            );
                          })
                        ],
                      ),
                      const Divider(
                        thickness: 2,
                        height: 40,
                        color: Colors.green,
                      ),
                      Obx(
                        () => Column(
                          children: [
                            //Quantity plus sign minus sigh and showing number
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "จำนวน".text.size(14).wider.white.make(),
                                Obx(
                                  //send item price to calculateTotalPrice on press button call the decrease Quantity method and calling a price calculation method by parsing the p_price to the function
                                  () => Row(children: [
                                    IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          controller.decreaseQuantity();
                                          controller.calculateTotalPrice(
                                              int.parse(data['c_price']));
                                        },
                                        //control the quantity input and set the style the them
                                        icon:
                                            const Icon(Icons.remove, size: 14)),
                                    controller.quantity.value.text.white
                                        .size(22)
                                        .make(),
                                    //call increase function on tap passing quantity value and price to the function's calling
                                    IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        controller.increaseQuantity(
                                            int.parse(data['c_quantity']));
                                        controller.calculateTotalPrice(
                                            int.parse(data['c_price']));
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        size: 14,
                                      ),
                                    ),
                                  ]),
                                ),
                                //total text with styles
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      "Total: "
                                          .text
                                          .size(14)
                                          .white
                                          .wider
                                          .make(),
                                      //show total price in currency format
                                      "฿".text.size(14).white.make(),
                                      "${controller.totalPrice.value}"
                                          .numCurrency
                                          .text
                                          .white
                                          .size(26)
                                          .wider
                                          .make()
                                    ]))
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        height: 40,
                        color: Colors.green,
                      ),
                      //description and style
                      //get product description and add the styles
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "คำอธิบายคอร์ส".text.size(16).wider.white.make(),
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: "${data['c_desc']}"
                                  .text
                                  .white
                                  .size(14)
                                  .wider
                                  .make(),
                            ),
                          ],
                        ),
                      )
                      //button section
                      //
                    ])),
              )),

              //add to cart button

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ourButton(
                    onPress: () {
                      if (controller.quantity.value > 0) {
                        controller.addToCart(
                          // color: data['p_colors'][controller.colorIndex.value],
                          context: context,
                          vendorId: data['vendor_id'],
                          img: data['c_imgs'][0],
                          qty: controller.quantity.value,
                          sellername: data['c_seller'],
                          title: data['c_name'],
                          tprice: controller.totalPrice.value,
                          // date: today.toString()
                        );
                        controller.resetValues();
                        VxToast.show(context, msg: "เพิ่มลงในรถเข็นแล้ว");
                        Get.back();
                      } else {
                        VxToast.show(context, msg: "โปรดระบุจำนวนด้วยค่ะ");
                      }
                    },
                    textColor: whiteColor,
                    title: "รถเข็น + "),
              ),
            ],
          ).box.gray900.make(),
        ),
      ).box.gray900.make(),
    );
  }
}
