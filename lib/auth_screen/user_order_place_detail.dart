import 'package:emart_app/consts/consts.dart';

Widget orderPlaceDetails({title1, title2, d1}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Row(
        children: [
          "$title1".text.wider.white.size(14).make(),
          " x '$d1' : ".text.white.size(16).make(),
        ],
      ),
      Row(
        children: [
          "฿".text.white.make(),
          "$title2".numCurrency.text.wider.white.size(20).make(),
        ],
      )
    ],
  );
}
