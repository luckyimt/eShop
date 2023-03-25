import 'package:emart_app/consts/consts.dart';

//create loading animation as red color as object to call from other class
Widget loadingIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(redColor),
  );
}
