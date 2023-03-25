import 'package:emart_app/auth_screen/user_upload_payment.dart';

import '../consts/consts.dart';
import 'package:emart_app/auth_screen/user_order_status.dart';
import 'package:get/get.dart';
import '../service/firestore_services.dart';
import 'user_order_place_detail.dart';

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String price = data['total_amount'].toString();
    String today = data['appointment'].toString();
    String timeOfDay = data['time'].toString();

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.pinkAccent, Colors.white])),
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: "คำสั่งซื้อ".text.white.wider.make(),
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  orderStatus(
                      color: Colors.white,
                      title: "สถานะ",
                      showDone: data['slip_verify']),

                  const Divider(
                      indent: 15,
                      endIndent: 15,
                      height: 30,
                      color: Colors.greenAccent,
                      thickness: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      "วันกำหนดเวลานัด"
                          .text
                          .size(16)
                          .color(Colors.white)
                          .wider
                          .make(),
                      10.heightBox,
                      "วันที่: ${data['appointment']}"
                          .text
                          .size(14)
                          .end
                          .color(Colors.white)
                          .wider
                          .semiBold
                          .make(),
                      5.heightBox,
                      "เวลา: ${data['time']}"
                          .text
                          .size(14)
                          .end
                          .semiBold
                          .color(Colors.white)
                          .wider
                          .make(),
                      5.heightBox,
                      "จำนวนที่เหลือ: ${data['tickets']}"
                          .text
                          .size(14)
                          .semiBold
                          .end
                          .color(Colors.white)
                          .wider
                          .make(),
                    ],
                  ),
                  const Divider(
                      indent: 10,
                      endIndent: 10,
                      height: 30,
                      color: Colors.greenAccent,
                      thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "รวม"
                          .text
                          .wider
                          .start
                          .size(16)
                          .color(Colors.white)
                          .make(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          "฿".text.size(14).white.make(),
                          "${data['total_amount']}"
                              .numCurrency
                              .text
                              .wider
                              .size(20)
                              .color(Colors.white)
                              .make(),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      "รายการ"
                          .text
                          .wider
                          .start
                          .size(16)
                          .color(Colors.white)
                          .make(),
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(data['orders'].length, (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              orderPlaceDetails(
                                title1: data['orders'][index]['title'],
                                title2: data['orders'][index]['tprice'],
                                d1: data['orders'][index]['qty'],
                              )
                            ],
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  //upload slip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style:
                            OutlinedButton.styleFrom(side: const BorderSide()),
                        onPressed: () {
                          FirestoreServices.deleteOrder(data.id);
                          Get.back();
                        },
                        child:
                            "ลบรายการ".text.size(14).color(Colors.white).make(),
                      ).box.make(),
                      OutlinedButton(
                        style:
                            OutlinedButton.styleFrom(side: const BorderSide()),
                        onPressed: () {
                          Get.to(
                            () => UploadPayment(
                                totalPrice: price,
                                today: today,
                                time: timeOfDay),
                          );
                        },
                        child: "อัพโหลดสลิป"
                            .text
                            .size(14)
                            .color(Colors.white)
                            .make(),
                      ).box.make(),
                    ],
                  )
                ],
              )
              // .box
              // .gray700
              // .shadowLg
              // .padding(EdgeInsetsDirectional.all(20))
              // .roundedLg
              // .make(),
              ),
        ),
      ),
    );
  }
}
