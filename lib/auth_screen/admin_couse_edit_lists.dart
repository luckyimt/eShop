import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/auth_screen/admin_course_edit.dart';
import 'package:get/get.dart';
import '../consts/consts.dart';
import '../service/firestore_services.dart';
import '../widget_common/loading_indicator.dart';

class editCourseListScreen extends StatelessWidget {
  final dynamic data;
  const editCourseListScreen({Key? key, this.data}) : super(key: key);

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
            title: "รายการคอร์ส".text.wider.white.make(),
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
              stream: FirestoreServices.getAllCourses(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: loadingIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return "ไม่พบสินค้าของฉัน"
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
                              borderRadius: BorderRadius.circular(30)),
                          leading: "${index + 1}".text.white.make(),
                          title: data[index]['c_name']
                              .toString()
                              .text
                              .wider
                              .size(14)
                              .white
                              .make(),
                          subtitle: data[index]['c_price']
                              .toString()
                              .numCurrency
                              .text
                              .wider
                              .size(18)
                              .white
                              .make(),
                          trailing: TextButton(
                            onPressed: () {
                              Get.to(() => EditCourseScreen(data: data[index]));
                            },
                            child: const Text("แก้ไข"),
                          ),
                        )
                            .box
                            .roundedLg
                            .shadowLg
                            .color(Colors.grey.shade900)
                            .make(),
                      );
                    },
                  );
                }
              })),
    );
  }
}
