import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/product_controller.dart';
import '../service/firestore_services.dart';
import 'package:get/get.dart';

import '../widget_common/loading_indicator.dart';
import 'user_course_detail.dart';

class CourseScreen extends StatefulWidget {
  final String? title;
  const CourseScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  var controller = Get.put(ProductController());
  dynamic productMethod;
  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      //สร้าง Appbar
      appBar: AppBar(
        title: 'ศิวิไลคลินิกคอร์ส'.text.wider.color(Colors.white).make(),
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
        stream: FirestoreServices.getCourse(widget.title),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //ตรวจว่าเจอข้อมูลไหม
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "No course found".text.color(Colors.white).make(),
            );
          } else {
            //ให้ดาต้าเก็บข้อมูลจากเอกสาร
            var data = snapshot.data!.docs;
            return Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      //put view scrolling in horizontal
                      scrollDirection: Axis.horizontal,
                    ),
                    Expanded(
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisExtent: 225,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              //pick image from network item name and price and show inside merchandise post
                              Image(
                                image: NetworkImage(
                                  '${data[index]['c_imgs'][0]}',
                                ),
                                width: 400,
                                height: 140,
                                fit: BoxFit.fitWidth,
                              ),
                              10.heightBox,
                              "${data[index]['c_name']}"
                                  .text
                                  .size(17)
                                  .wider
                                  .white
                                  .make(),
                              10.heightBox,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  "฿".text.size(16).white.make(),
                                  "${data[index]['c_price']}"
                                      .numCurrency
                                      .text
                                      .white
                                      .size(20)
                                      .make(),
                                ],
                              ),
                              const Divider(
                                  thickness: 2, color: (Colors.green)),
                            ],
                          ).onTap(
                            () {
                              controller.checkIfFav(data[index]);
                              //
                              Get.to(() => CourseDetails(
                                    title: "${data[index]['c_name']}",
                                    data: data[index],
                                  ));
                            },
                          );
                        },
                      ),
                    )
                  ],
                ));
          }
        },
      ),
    );
  }
}
