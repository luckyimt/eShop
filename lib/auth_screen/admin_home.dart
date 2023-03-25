import 'package:emart_app/auth_screen/admin_couse_edit_lists.dart';
import 'package:emart_app/auth_screen/admin_payment_screen.dart';
import 'package:emart_app/auth_screen/admin_product_upload.dart';
import 'package:emart_app/widget_common/cart_detail.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'admin_order_screen.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //init home controller
    var controller = Get.put(HomeController());
    //create navigator bar with image labeled
    var navbarItem = [
      BottomNavigationBarItem(
          icon: Image.asset(icHome, width: 26), label: "คำสั่งซื้อ"),
      BottomNavigationBarItem(
          icon: Image.asset(icCategories, width: 26), label: "เพิ่มคอร์ส"),
      BottomNavigationBarItem(
          icon: Image.asset(icShop, width: 26), label: "แก้ไขคอร์ส"),
      BottomNavigationBarItem(
          icon: Image.asset(icSlip, width: 26), label: "สลิป"),
    ];
    //add bodies to the nav
    var navBody = [
      const AdminHomeScreen(),
      const UploadProductScreen(),
      const editCourseListScreen(),
      const AdminPaymentScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => exitDialog(context));
        return false;
      },
      //create navigation bar with indexes value to view the current page
      child: Scaffold(
        body: Column(
          children: [
            //create index for each page
            Obx(() => Expanded(
                child: navBody.elementAt(controller.currentNavIndex.value))),
          ],
        ),
        bottomNavigationBar: Obx(
          //for each index item create the bar with changeable pages
          () => BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            selectedItemColor: redColor,
            selectedLabelStyle: const TextStyle(fontFamily: semibold),
            type: BottomNavigationBarType.fixed,
            backgroundColor: whiteColor,
            items: navbarItem,
            onTap: (value) {
              //sending value to indexing the page selected
              controller.currentNavIndex.value = value;
            },
          ),
        ),
      ),
    );
  }
}
