import 'package:emart_app/consts/consts.dart';

Widget orderStatusConfirmation({title, showDone}) {
  return ListTile(
    subtitle: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        "$title".text.wider.size(16).color(Colors.white).make(),
        showDone
            ? "ชำระเงินเรียบร้อย".text.white.make()
            : "กรุณาตรวจสอบ'สลิป'".text.white.make(),
      ],
    ).box.gray900.make(),
  );
}
