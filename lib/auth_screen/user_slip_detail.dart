import 'package:emart_app/auth_screen/user_order_place_detail.dart';

import '../consts/consts.dart';
import 'package:get/get.dart';

import '../service/firestore_services.dart';

class OrderSlipDetails extends StatefulWidget {
  final dynamic data;
  const OrderSlipDetails({Key? key, this.data}) : super(key: key);

  @override
  State<OrderSlipDetails> createState() => _OrderSlipDetailState();
}

class _OrderSlipDetailState extends State<OrderSlipDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.pinkAccent, Colors.white])),
      child: Scaffold(
          appBar: AppBar(
            title: "ใบเสร็จ".text.wider.make(),
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
          backgroundColor: Colors.grey.shade900,
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: GridView.builder(
                itemCount: 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, mainAxisExtent: 700),
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(
                        //แสดงภาพสินค้าทีละภาพจากดาต้าเบส
                        widget.data['paid_imgs'][index],
                        fit: BoxFit.contain,
                        scale: 0.7,
                        //กำหนดความกว้างและกำหนดให้ขนาดพอดีกับความกว้างจอ
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                "ชื่อลูกค้า : ".text.size(18).white.make(),
                                widget.data['name']
                                    .toString()
                                    .text
                                    .size(20)
                                    .white
                                    .make(),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  "จำนวนเงิน".text.size(16).wider.white.make(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                "฿ ".text.white.make(),
                                widget.data['total']
                                    .toString()
                                    .numCurrency
                                    .text
                                    .size(26)
                                    .white
                                    .wider
                                    .make(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                          indent: 110,
                          endIndent: 110,
                          height: 3,
                          color: Colors.greenAccent,
                          thickness: 1),
                      TextButton(
                          onPressed: () {
                            FirestoreServices.deleteSlip(widget.data.id);
                            Get.back();
                          },
                          child: const Text("ลบสลิป")),
                    ],
                  )
                      .box
                      .gray900
                      .shadowLg
                      .padding(EdgeInsetsDirectional.all(10))
                      .roundedLg
                      .make();
                }),
          )),
    );
  }
}
