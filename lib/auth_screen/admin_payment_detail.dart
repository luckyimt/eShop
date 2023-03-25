import '../consts/consts.dart';
import 'package:get/get.dart';

import '../service/firestore_services.dart';

class PaymentDetails extends StatelessWidget {
  final dynamic data;
  const PaymentDetails({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
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
        body: GridView.builder(
            itemCount: 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, mainAxisExtent: 620),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          Image.network(
                            //แสดงภาพสินค้าทีละภาพจากดาต้าเบส
                            data['paid_imgs'][index],
                            height: 420,
                            fit: BoxFit.contain,
                            //กำหนดความกว้างและกำหนดให้ขนาดพอดีกับความกว้างจอ
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          FirestoreServices.deleteSlip(data.id);
                          Get.back();
                        },
                        child: const Text("ลบสลิป")),
                    const Divider(
                        thickness: 2,
                        color: Colors.greenAccent,
                        indent: 20,
                        endIndent: 20,
                        height: 30),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: "จำนวนเงิน".text.white.size(16).wider.make(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              "฿ ".text.white.make(),
                              data['total']
                                  .toString()
                                  .numCurrency
                                  .text
                                  .white
                                  .size(26)
                                  .wider
                                  .make(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
