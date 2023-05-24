import 'package:asasui/app/layouts/Cart.dart';
import 'package:asasui/app/layouts/ClientPanel.dart';
import 'package:asasui/app/layouts/ViewBillingDetail.dart';
import 'package:flutter/material.dart';

import 'widgets/MainAppBar.dart';

class ClientOrderStatus extends StatefulWidget {
  var orderStatus;
  ClientOrderStatus({Key? key, required this.orderStatus}) : super(key: key);

  @override
  State<ClientOrderStatus> createState() => _ClientOrderStatusState();
}

class _ClientOrderStatusState extends State<ClientOrderStatus> {
  bool status = false;
  // Future orderStatus() {
  //   if (widget.orderStatus != null) {}
  // }

  Widget orderStatus() {
    if (widget.orderStatus != null) {
      return successMessage();
    } else {
      return failureMessage();
    }
  }

  Widget successMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                      'Your order has been placed #orderId: ${widget.orderStatus['billingId']}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox( width: 20,),
                  SizedBox(
                    width: 1000,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pushReplacementNamed(context, '/store', arguments: qrValue);
                        // Navigator.pushReplacementNamed(context, '/panel');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewBillingDetail(
                                billingId: widget.orderStatus['billingId'])));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('View bill'),
                    ),
                  ),
                  const SizedBox( width: 10,),
                          SizedBox(
                    width: 1000,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pushReplacementNamed(context, '/store', arguments: qrValue);
                        // Navigator.pushReplacementNamed(context, '/panel');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ClientPanel()));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Home'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget failureMessage() {
    return const Text('Your order is not placed. Please try again latter!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        backOption: false,
      ),
      backgroundColor: const Color.fromARGB(245, 255, 227, 186),
      body: orderStatus(),
    );
  }
}
