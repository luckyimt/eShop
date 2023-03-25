import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/auth_screen/user_slip_detail.dart';
import 'package:get/get.dart';
import '../consts/consts.dart';
import '../service/firestore_services.dart';
import '../widget_common/loading_indicator.dart';

class OrdersSlip extends StatelessWidget {
  const OrdersSlip({Key? key}) : super(key: key);

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
            title: "ใบเสร็จของฉัน".text.wider.color(Colors.white).make(),
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
          body: Container(
            child: StreamBuilder(
                stream: FirestoreServices.getOrderSlip(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: loadingIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return "ไม่พบใบเสร็จของคำสั่งซื้อนี้"
                        .text
                        .color(darkFontGrey)
                        .makeCentered();
                  } else {
                    var data = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            leading:
                                "${index + 1}".text.color(Colors.white).make(),
                            title: data[index]['name']
                                .toString()
                                .text
                                .white
                                .make(),
                            subtitle: data[index]['total']
                                .toString()
                                .numCurrency
                                .text
                                .wider
                                .size(16)
                                .color(Colors.white)
                                .make(),
                            trailing: IconButton(
                              onPressed: () {
                                Get.to(
                                    () => OrderSlipDetails(data: data[index]));
                              },
                              icon: const Icon(
                                Icons.next_plan_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ).box.roundedLg.shadowLg.gray900.make(),
                        );
                      },
                    );
                  }
                }),
          ).box.roundedLg.padding(const EdgeInsets.all(1)).make()),
    );
  }
}
