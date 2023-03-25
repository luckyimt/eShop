import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/auth_screen/user_order_confirmation_screen.dart';
import 'package:emart_app/consts/consts.dart';
import '../controllers/cart_controller.dart';
import '../service/firestore_services.dart';
import '../widget_common/loading_indicator.dart';
import '../widget_common/our_button.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool hasCart = false;
    var controller = Get.put(CartController());
    //create bottom nav bar to get to shipping input form
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.pinkAccent, Colors.white])),
      child: Scaffold(
          appBar: AppBar(
            title: "รถเข็น".text.wider.white.make(),
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 45,
              child: ourButton(
                onPress: () {
                  if (hasCart == true) {
                    Get.to(() => const OrderConfirmationScreen());
                  } else {
                    VxToast.show(context,
                        msg: 'กรุณาเลือกคอร์สก่อนชำระเงินค่ะ');
                  }
                },
                title: "ชำระเงิน",
              ),
            ),
          ),
          //show shopping cart text on screen

          //stream loading 'cart items' from 'getCart Method' for a current user
          body: StreamBuilder(
            stream: FirestoreServices.getCart(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //if there is any item show loading indication
              if (!snapshot.hasData) {
                hasCart = true;
                return Center(
                  child: loadingIndicator(),
                );
                //if there is nothing to show says Cart is empty
              } else if (snapshot.data!.docs.isEmpty) {
                hasCart = false;
                return Center(
                  child: "รถเข็นว่าง".text.black.make(),
                );
                //if there are data loaded show the inside the layout
              } else {
                var data = snapshot.data!.docs;
                controller.calculate(data);
                controller.productSnapshot = data;
                //and return item's title and price
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  //create a a column of boxes  containing item's image , title and price
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ListTile(
                                    tileColor: Colors.pink.shade200,
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        '${data[index]['img']}',
                                      ),
                                    ),
                                    title:
                                        "${data[index]['title']} x${data[index]['qty']}"
                                            .text
                                            .size(14)
                                            .color(Colors.white)
                                            .make(),
                                    subtitle: "${data[index]['tprice']}"
                                        .numCurrency
                                        .text
                                        .size(18)
                                        .color(Colors.white)
                                        .make(),
                                    trailing: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 20,
                                    ).onTap(() {
                                      FirestoreServices.deleteDocument(
                                          data[index].id);
                                    }),
                                  ),
                                );
                              })),
                      //create a total price text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "ยอดรวม : "
                              .text
                              .wider
                              .size(18)
                              .color(Colors.white)
                              .make(),
                          Row(
                            children: [
                              "฿"
                                  .text
                                  .wider
                                  .size(16)
                                  .color(Colors.white)
                                  .make(),
                              // continue to show total price in currency format
                              Obx(
                                () => "${controller.totalP.value}"
                                    .numCurrency
                                    .text
                                    .size(22)
                                    .wider
                                    .color(Colors.white)
                                    .make(),
                              ),
                            ],
                          )
                        ],
                      )
                          //within a rounded box size = screen Width - 60
                          .box
                          .padding(const EdgeInsets.all(20))
                          .make(),
                    ],
                  )
                      .box
                      .roundedLg
                      .shadowLg
                      .color(Colors.grey.shade900)
                      .padding(const EdgeInsets.all(10.0))
                      .make(),
                );
              }
            },
          )),
    );
  }
}
