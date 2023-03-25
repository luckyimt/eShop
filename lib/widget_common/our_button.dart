import 'package:emart_app/consts/consts.dart';

Widget ourButton({onPress, color, textColor, String? title}) {
  return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: Ink(
          decoration: BoxDecoration(
              gradient:
                  const LinearGradient(colors: [Colors.white, Colors.pink]),
              borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
                // color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(10)),
            height: 60,
            alignment: Alignment.center,
            child: title!.text.color(Colors.white).size(16).make(),
          )));
}
