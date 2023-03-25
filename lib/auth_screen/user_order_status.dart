import 'package:emart_app/consts/consts.dart';

Widget orderStatus({color, title, showDone}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "$title".text.size(18).wider.color(Colors.white).make(),
              showDone
                  ? ": คำสั่งซ์้ือได้รับการชำระเงินแล้ว"
                      .text
                      .wider
                      .white
                      .size(14)
                      .make()
                  : ": กำลังรอการชำระเงิน"
                      .text
                      .wider
                      .white
                      .semiBold
                      .size(14)
                      .make(),
            ],
          ),
        ],
      ),
    ],
  );
}
