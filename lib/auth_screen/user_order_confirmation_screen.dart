import 'package:emart_app/auth_screen/user_upload_payment.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/cart_controller.dart';
import '../widget_common/loading_indicator.dart';
import '../widget_common/our_button.dart';
import 'package:get/get.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final dynamic data;
  const OrderConfirmationScreen({super.key, this.data});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  DateTime today = DateTime.now();
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 0, minute: 00);
  void _showTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        if (value != null) {
          _timeOfDay = value!;
        } else {
          VxToast.show(context, msg: 'กรุณาเลือกเวลา');
        }
      });
    });
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.pinkAccent, Colors.white])),
      child: Scaffold(
          //create scaffold and shipping info on appbar text
          appBar: AppBar(
            shape: Vx.withRounded(45),
            title: "เลือกวันนัดพบแพทย์".text.wider.color(Colors.white).make(),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.pinkAccent,
                      Colors.white,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
          ),
          // the address input validation
          bottomNavigationBar: SizedBox(
            height: 60,
            child: controller.placingOrder.value
                ? Center(
                    child: loadingIndicator(),
                  )
                : ourButton(
                    onPress: () async {
                      if ((today.isAfter(DateTime.now())) &&
                          (controller.totalP.value != 0)) {
                        await controller.placeMyOrder(
                            // orderPaymentMethod:
                            // paymentMethods[controller.paymentIndex.value],
                            totalAmount: controller.totalP.value,
                            time: _timeOfDay.format(context).toString(),
                            date:
                                'Mo: ${today.month.toString()}/D: ${today.day.toString()}/Yr: ${today.year.toString()}');
                        await controller.clearCart();
                        await Get.to(() => UploadPayment(
                            totalPrice: controller.totalP.toString(),
                            time: _timeOfDay.toString(),
                            today:
                                '${today.month.toString()}/${today.day.toString()}/${today.year.toString()}'));
                        // Get.to(makePayment(totalP: controller.totalP.toString()));
                        // Get.to(() => PaypalPayment(
                        //       totalP: controller.totalP.value,
                        //       onFinish: (number) async {
                        //         // payment done
                        //         final snackBar = SnackBar(
                        //           content:
                        //               const Text("Payment done Successfully"),
                        //           duration: const Duration(seconds: 5),
                        //           action: SnackBarAction(
                        //             label: 'Close',
                        //             onPressed: () {
                        //               // Some code to undo the change.
                        //             },
                        //           ),
                        //         );
                        //         // _scaffoldKey.currentState!.showSnackBar(snackBar);
                        //       },
                        //     ));
                        //get to payment page

                      } else {
                        //print 'please fill all form'
                        VxToast.show(context,
                            msg:
                                "กรุณาเลือกคอร์ส และเวลา-วันที่ ให้ถูกต้องด้วยค่ะ");
                      }
                    },
                    color: redColor,
                    textColor: whiteColor,
                    title: "ยืนยัน",
                  ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // customTextField(
                  //     hint: "Line ID",
                  //     isPass: false,
                  //     title: "Line",
                  //     controller: controller.lineController),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "เ ลื อ ก วั น พ บ แ พ ท ย์: ${today.toString().split(" ")[0]}",
                        ),
                        10.heightBox,
                        TableCalendar(
                            rowHeight: 45,
                            locale: "en_US",
                            headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true),
                            availableGestures: AvailableGestures.all,
                            selectedDayPredicate: (day) =>
                                isSameDay(day, today),
                            focusedDay: today,
                            firstDay: DateTime.utc(2022, 1, 1),
                            lastDay: DateTime.utc(2031, 12, 31),
                            onDaySelected: _onDaySelected),
                        10.heightBox,
                        const Divider(),
                        10.heightBox,
                        "เลือกเวลานัดพบแพทย์".text.size(14).wider.make(),
                        20.heightBox,
                        Text(_timeOfDay.format(context).toString(),
                            style: const TextStyle(fontSize: 16)),
                        20.heightBox,
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                            color: Colors.transparent,
                          )),
                          onPressed: _showTimePicker,
                          child: 'เลือกเวลา'
                              .text
                              .size(14)
                              .color(Colors.pink)
                              .make(),
                        )
                            .box
                            .color(Colors.pink.shade100)
                            .roundedLg
                            .shadowLg
                            .color(Colors.pink.shade50)
                            .make(),
                        // TimePickerSpinner(
                        //   is24HourMode: false,
                        //   normalTextStyle: TextStyle(
                        //     fontSize: 14,
                        //     color: Colors.grey,
                        //   ),
                        //   highlightedTextStyle:
                        //       TextStyle(fontSize: 14, color: Colors.black),
                        //   spacing: 28,
                        //   itemHeight: 40,
                        //   isForce2Digits: true,
                        //   onTimeChange: (time) {
                        //     setState(() {
                        //       _dateTime = time;
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
