import 'package:emart_app/consts/consts.dart';

Widget detailsCard({width, String? count, String? title}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      title!.text.wider.color(Colors.white).size(16).make(),
      7.heightBox,
      count!.text.color(Colors.white).size(14).make(),
    ],
  )
      .box
      .color(Colors.grey.shade900)
      .roundedLg
      .shadowLg
      .width(width)
      .padding(const EdgeInsets.all(10))
      .make();
}
