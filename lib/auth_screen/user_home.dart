import 'package:emart_app/auth_screen/user_cart_screen.dart';
import 'package:emart_app/auth_screen/user_course_category.dart';
import 'package:emart_app/auth_screen/user_profile_screen.dart';
import 'package:emart_app/auth_screen/user_slip_screen.dart';
import 'package:emart_app/widget_common/cart_detail.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //init home controller
    var controller = Get.put(HomeController());
    //create navigator bar with image labeled
    var navbarItem = [
      BottomNavigationBarItem(
          icon: Image.asset(color: Colors.black, icCategories, width: 20),
          label: 'คอร์ส'),
      BottomNavigationBarItem(
          icon: Image.asset(color: Colors.black, icCart, width: 20),
          label: 'รถเข็น'),
      BottomNavigationBarItem(
          icon: Image.asset(color: Colors.black, icSlip, width: 20),
          label: 'สลิป'),
      BottomNavigationBarItem(
          icon: Image.asset(color: Colors.black, icProfile, width: 20),
          label: 'บัญชี'),
    ];
    //add bodies to the nav
    var navBody = [
      const CourseScreen(title: course),
      const CartScreen(),
      const OrdersSlip(),
      const ProfileScreen(),
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
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
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
