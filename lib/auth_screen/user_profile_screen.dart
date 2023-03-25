import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/auth_screen/edit_profile_screen.dart';
import 'package:emart_app/auth_screen/user_order_screen.dart';
import 'package:emart_app/auth_screen/user_wishlist_screen.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/profile_controller.dart';
import 'package:emart_app/service/firestore_services.dart';
import 'package:emart_app/splash_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../chat_screen/message_screen.dart';
import '../component/detail_card.dart';
import '../consts/lists.dart';
import '../controllers/auth_controller.dart';
import '../widget_common/loading_indicator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
//add background widget and streaming user's data
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.pinkAccent, Colors.white])),
      child: Scaffold(
        appBar: AppBar(
          title: "บัญชี".text.wider.white.make(),
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
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                //show circle progress indicator if there is data inside the user document
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else {
              //
              var data = snapshot.data!.docs[0];
              return Column(children: [
                //edit profile button
                const Icon(Icons.edit, color: whiteColor).onTap(() {
                  controller.nameController.text = data['name'];
                  controller.newpassController.text = data['password'];
                  Get.to(() => EditProfileScreen(data: data));
                }),
                //use detail section
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        data['imageUrl'] == ''
                            ? Image.asset(imgProfile2,
                                    width: 100, fit: BoxFit.cover)
                                .box
                                .roundedFull
                                .clip(Clip.antiAlias)
                                .make()
                            : Image.network(data['imageUrl'],
                                    width: 100, fit: BoxFit.cover)
                                .box
                                .roundedFull
                                .clip(Clip.antiAlias)
                                .make(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data['name']}"
                                  .text
                                  .size(16)
                                  .color(Colors.black)
                                  .make(),
                              5.heightBox,
                              "${data['email']}"
                                  .text
                                  .size(16)
                                  .color(Colors.black)
                                  .make(),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                            color: Colors.transparent,
                          )),
                          onPressed: () {
                            // FirebaseAuth.instance.signOut();

                            Get.put(AuthController()).signoutMethod(context);
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => SplashScreen()));
                            Get.offAll(() => const SplashScreen());
                          },
                          child: "ออกจากระบบ"
                              .text
                              .size(14)
                              .color(Colors.white)
                              .make(),
                        )
                            .box
                            .color(Colors.grey.shade900)
                            .roundedLg
                            .shadowLg
                            .make()
                      ],
                    )),
                10.heightBox,
                FutureBuilder(
                  future: FirestoreServices.getCounts(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: loadingIndicator());
                    } else {
                      var countData = snapshot.data;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          detailsCard(
                              count: countData[0].toString(),
                              title: "ในรถเข็น",
                              width: context.screenWidth / 3.4),
                          detailsCard(
                              count: countData[1].toString(),
                              title: "อยากได้",
                              width: context.screenWidth / 3.3),
                          detailsCard(
                              count: countData[2].toString(),
                              title: "คำสั่งซื้อ",
                              width: context.screenWidth / 3.4),
                        ],
                      );
                    }
                  },
                ),
                10.heightBox,
                //button section
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return const Divider(color: Colors.white);
                  },
                  itemCount: profileButtonsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.to(() => const OrdersScreen());
                            break;
                          case 1:
                            Get.to(() => const WishlistScreen());
                            break;
                          case 2:
                            Get.to(() => const MessagesScreen());
                            break;
                        }
                      },
                      leading: Image.asset(
                        profileButtonIcon[index],
                        width: 20,
                      ),
                      title: profileButtonsList[index]
                          .text
                          .size(14)
                          .fontFamily(semibold)
                          .color(Colors.white)
                          .make(),
                    ).box.roundedLg.shadowLg.color(Colors.grey.shade900).make();
                    ;
                  },
                )
              ]);
            }
          },
        ),
      ),
    );
  }
}
