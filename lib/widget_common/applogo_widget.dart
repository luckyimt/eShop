import 'package:emart_app/consts/consts.dart';

//widget containing an icAppLogo inside a rounded box
Widget applogoWidget() {
  return Image.asset(icAppLogo)
      .box
      .white
      .size(300, 300)
      .padding(const EdgeInsets.all(0))
      .rounded
      .make();
}
