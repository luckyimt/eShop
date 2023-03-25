import 'package:emart_app/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'paypalPayment.dart';

class makePayment extends StatefulWidget {
  final String totalP;
  const makePayment({
    Key? key,
    required this.totalP,
  }) : super(key: key);

  @override
  _makePaymentState createState() => _makePaymentState();
}

class _makePaymentState extends State<makePayment> {
  TextStyle style = const TextStyle(fontFamily: 'Open Sans', fontSize: 15.0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Paypal Payment',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  const Text(
                    "Items in your Cart",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  ListTile(
                      title: const Text(
                        "Product: One plus 10",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        "Quantity: 1",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      trailing: widget.totalP.text.make())
                ],
              ),
              // TextButton(
              //   onPressed: () {
              //     // make PayPal payment
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (BuildContext context) => PaypalPayment(
              //           onFinish: (number) async {
              //             // payment done
              //             final snackBar = SnackBar(
              //               content: const Text("Payment done Successfully"),
              //               duration: const Duration(seconds: 5),
              //               action: SnackBarAction(
              //                 label: 'Close',
              //                 onPressed: () {
              //                   // Some code to undo the change.
              //                 },
              //               ),
              //             );
              //             // _scaffoldKey.currentState!.showSnackBar(snackBar);
              //           },
              //           totalP: '',
              //         ),
              //       ),
              //     );
              //   },
              //   child: const Text(
              //     'Pay with Paypal',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
            ],
          )),
    );
  }
}
