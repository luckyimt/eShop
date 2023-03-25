import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/auth_screen/user_orders_details.dart';
import 'package:get/get.dart';
import '../consts/consts.dart';
import '../service/firestore_services.dart';
import '../widget_common/loading_indicator.dart';
import 'admin_payment_detail.dart';

class AdminPaymentScreen extends StatelessWidget {
  const AdminPaymentScreen({Key? key}) : super(key: key);

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
            title: "สลิปใบเสร็จ".text.wider.color(Colors.white).make(),
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
          body: StreamBuilder(
              stream: FirestoreServices.getAllPayment(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: loadingIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return "ยังไม่มีรายการใบเสร็จ!"
                      .text
                      .color(darkFontGrey)
                      .makeCentered();
                } else {
                  var data = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListTile(
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45)),
                          leading: "${index + 1}"
                              .text
                              .size(18)
                              .color(Colors.white)
                              .make(),
                          title: data[index]['name']
                              .toString()
                              .text
                              .wider
                              .size(16)
                              .color(Colors.white)
                              .make(),
                          subtitle: data[index]['total']
                              .toString()
                              .numCurrency
                              .text
                              .wider
                              .size(18)
                              .color(Colors.white)
                              .make(),
                          trailing: TextButton(
                            onPressed: () {
                              Get.to(() => PaymentDetails(data: data[index]));
                            },
                            child: const Text("เปิดสลิป"),
                          ),
                        )
                            .box
                            .roundedLg
                            .color(Colors.grey.shade900)
                            .shadowLg
                            .make(),
                      );
                    },
                  );
                }
              }).box.roundedLg.padding(EdgeInsets.all(1)).make()),
    );
  }
}
