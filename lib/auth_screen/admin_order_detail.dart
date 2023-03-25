import 'package:cloud_firestore/cloud_firestore.dart';

import '../consts/consts.dart';
import 'package:emart_app/auth_screen/user_order_place_detail.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../service/firestore_services.dart';
import 'admin_order_confirmation.dart';

class OrdersConfirmDetails extends StatelessWidget {
  final dynamic data;
  const OrdersConfirmDetails({Key? key, this.data}) : super(key: key);

  updateAppointment(appoint, docId) async {
    var store = firestore.collection(ordersCollection).doc(docId);
    store.set({'appointment': appoint}, SetOptions(merge: true));
  }

  courseAmountLeft(amount, docId) async {
    var store = firestore.collection(ordersCollection).doc(docId);
    store.set({'tickets': amount}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    var appointController = TextEditingController();
    var amountController = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: "เวลานัด".text.wider.make(),
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
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                5.heightBox,
                Column(
                  children: [
                    "กำหนดวันเวลานัดหมาย"
                        .text
                        .size(16)
                        .color(Colors.white)
                        .wider
                        .make(),
                    10.heightBox,
                    // const Divider(
                    //     indent: 170,
                    //     endIndent: 170,
                    //     height: 30,
                    //     color: Colors.greenAccent,
                    //     thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "วันที่".text.size(14).white.make(),
                            "เวลานัด".text.size(14).white.make(),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            "${data['appointment']}"
                                .text
                                .size(18)
                                .color(Colors.white)
                                .wider
                                .make(),
                            "${data['time']}"
                                .text
                                .size(18)
                                .color(Colors.white)
                                .wider
                                .make(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // const Divider(
                //     indent: 20,
                //     endIndent: 20,
                //     height: 40,
                //     color: Colors.greenAccent,
                //     thickness: 2),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'วัน/เดือน/ปี';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            appointController.text = value;
                          },
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          updateAppointment(appointController.text, data.id);
                        },
                        child: const Text("กำหนดวันนัดหมาย")),
                  ],
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'จำนวนครั้งที่เหลือ';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          amountController.text = value;
                        },
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        courseAmountLeft(amountController.text, data.id);
                      },
                      child: const Text("ระบุจำนวนครั้งที่เหลือ")),
                ]),
                const Divider(
                    indent: 20,
                    endIndent: 20,
                    height: 40,
                    color: Colors.greenAccent,
                    thickness: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    "ข้อมูลผู้ใช้งาน"
                        .text
                        .start
                        .size(14)
                        .color(Colors.white)
                        .wider
                        .make(),
                    // const Divider(
                    //     indent: 140,
                    //     endIndent: 140,
                    //     height: 20,
                    //     color: Colors.greenAccent,
                    //     thickness: 1),
                    5.heightBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            "Username: "
                                .text
                                .size(16)
                                .color(Colors.white)
                                .wider
                                .make(),
                            "${data['order_by_username']}"
                                .text
                                .size(16)
                                .center
                                .color(Colors.white)
                                .wider
                                .make(),
                          ],
                        ),
                      ],
                    ),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        "Phone: "
                            .text
                            .wider
                            .color(Colors.white)
                            .size(16)
                            .make(),
                        "${data['order_by_phone']}"
                            .text
                            .wider
                            .color(Colors.white)
                            .size(16)
                            .make(),
                      ],
                    ),
                  ],
                ),
                const Divider(
                    indent: 20,
                    endIndent: 20,
                    height: 40,
                    color: Colors.greenAccent,
                    thickness: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    "รายละเอียด"
                        .text
                        .wider
                        .start
                        .size(14)
                        .color(Colors.white)
                        .make(),
                    10.heightBox,
                    // const Divider(
                    //     indent: 150,
                    //     endIndent: 150,
                    //     height: 20,
                    //     color: Colors.greenAccent,
                    //     thickness: 2),
                    ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(data['orders'].length, (index) {
                        return Column(
                          children: [
                            orderPlaceDetails(
                              title1: data['orders'][index]['title'],
                              title2: data['orders'][index]['tprice'],
                              d1: data['orders'][index]['qty'],
                            )
                          ],
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "ราคารวม  :".text.start.wider.size(18).white.make(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            "฿".text.white.make(),
                            data['total_amount']
                                .toString()
                                .numCurrency
                                .text
                                .wider
                                .white
                                .size(20)
                                .make(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                10.heightBox,
                const Divider(
                    indent: 20,
                    endIndent: 20,
                    height: 3,
                    color: Colors.greenAccent,
                    thickness: 2),
                Column(
                  children: [
                    orderStatusConfirmation(
                        title: "สถานะการชำระเงิน",
                        showDone: data['slip_verify']),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide()),
                          onPressed: () {
                            FirestoreServices.deleteOrder(data.id);
                            Get.back();
                          },
                          child: "ลบคำสั่งซื้อ"
                              .text
                              .size(14)
                              .color(Colors.white)
                              .make(),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide()),
                          onPressed: () async {
                            await controller.confirmed(data.id, context);
                            Get.back();
                          },
                          child: "ยืนยันสลิป"
                              .text
                              .size(14)
                              .color(Colors.white)
                              .make(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )));
  }
}
