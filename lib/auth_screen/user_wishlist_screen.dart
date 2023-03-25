import 'package:cloud_firestore/cloud_firestore.dart';
import '../consts/consts.dart';
import '../service/firestore_services.dart';
import '../widget_common/loading_indicator.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: Vx.withRounded(45),
        title: "My Wishlist".text.color(darkFontGrey).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getWishlists(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No wishlist yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Image.network(
                          "${data[index]['c_imgs'][0]}",
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        title: "${data[index]['c_name']}"
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .size(16)
                            .make(),
                        subtitle: "${data[index]['c_price']}"
                            .numCurrency
                            .text
                            .size(16)
                            .color(redColor)
                            .fontFamily(semibold)
                            .make(),
                        trailing: const Icon(
                          Icons.favorite,
                          color: redColor,
                        ).onTap(() async {
                          await firestore
                              .collection(productsCollection)
                              .doc(data[index].id)
                              .set({
                            'p_wishlist':
                                FieldValue.arrayRemove([currentUser!.uid])
                          }, SetOptions(merge: true));
                        }),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
