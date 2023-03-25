import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../consts/consts.dart';
import '../service/firestore_services.dart';
import '../widget_common/loading_indicator.dart';
import 'admin_order_detail.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

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
            title: "คำสั่งซื้อ".text.wider.make(),
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
              stream: FirestoreServices.getAdminOrders(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: loadingIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return "No confirmation yet!".text.black.makeCentered();
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
                              borderRadius: BorderRadius.circular(30)),
                          leading: "${index + 1}".text.white.make(),
                          title: data[index]['order_by_username']
                              .toString()
                              .text
                              .white
                              .wider
                              .make(),
                          subtitle: data[index]['appointment']
                              .toString()
                              .text
                              .white
                              .wider
                              .make(),
                          trailing: TextButton(
                            onPressed: () {
                              Get.to(() =>
                                  OrdersConfirmDetails(data: data[index]));
                            },
                            child: Text("รายละเอียด"),
                          ),
                        ).box.gray900.roundedLg.shadowLg.make(),
                      );
                    },
                  );
                }
              })),
    );
  }
}
