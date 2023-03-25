import 'package:emart_app/consts/consts.dart';

//creating text field pattern the required title , hint and Password type and it's styles
Widget customTextField({String? title, String? hint, controller, isPass}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(Colors.black).size(16).make(),
      TextFormField(
        obscureText: isPass,
        controller: controller,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
          hintText: hint,
          isDense: true,
          fillColor: Colors.white,
          filled: true,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
        ),
      ),
      2.heightBox,
    ],
  );
}
