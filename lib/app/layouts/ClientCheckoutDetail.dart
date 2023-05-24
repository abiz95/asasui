import 'dart:convert';

import 'package:asasui/app/layouts/ClientOrderStatus.dart';
import 'package:asasui/app/layouts/ClientPanel.dart';
import 'package:asasui/app/services/PaymentService.dart';
import 'package:flutter/material.dart';

import '../services/AuthService.dart';
import 'widgets/CartOrderList.dart';
import 'widgets/MainAppBar.dart';

class ClientCheckoutDetail extends StatefulWidget {
  var orderList;
  ClientCheckoutDetail({Key? key, required this.orderList}) : super(key: key);

  @override
  State<ClientCheckoutDetail> createState() => _ClientCheckoutDetailState();
}

class _ClientCheckoutDetailState extends State<ClientCheckoutDetail> {
  double totalamt = 0;
  void calculateTotalAmount() {
    // var response = jsonDecode(widget.orderList[0]);
    for (var k in widget.orderList) {
      //  jsonData.add(k);  //adding each value to the list
      print('test loop value ${k['totalAmount']}');
      totalamt += k['totalAmount'];
    }
  }

  Future<dynamic> getPaymentGateway() async {
    String clientId = await AuthService().decodeJwt('userId');
    var paymentGatewayResponse =
        await PaymentService().getPaymentGateway(clientId);
    print('getPaymentGateway body');
    print(paymentGatewayResponse.data['data'].toString());
    // print(storeDetailResponse.data['data'][0]['clientImage'].toString());
    var test = paymentGatewayResponse.data['data'];
    if (paymentGatewayResponse.statusCode == 200) {
      // print('test obj');
      // print(test['productName']);
      // cartList = storeDetailResponse.data['data'];
      // orderList = storeDetailResponse.data['data'];
      // return paymentGatewayResponse.data['data'];
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClientOrderStatus(
                orderStatus: paymentGatewayResponse.data['data'][0],
              )));
    } else {
      // return null;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClientOrderStatus(
                orderStatus: null,
              )));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateTotalAmount();
    print('Total price: $totalamt');
    return Scaffold(
      appBar: const MainAppBar(
        backOption: false,
      ),
      backgroundColor: const Color.fromARGB(245, 255, 227, 186),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Checkout', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 10,),
                      Text('Total price: £ $totalamt'),
                      const Text('Discount: £ 0'),
                      const Divider(),
                      Text('Billing amount: £ $totalamt'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 1000,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pushReplacementNamed(context, '/store', arguments: qrValue);
                        // Navigator.pushReplacementNamed(context, '/panel');
                        getPaymentGateway();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text('Make payment'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 1000,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pushReplacementNamed(context, '/store', arguments: qrValue);
                        // Navigator.pushReplacementNamed(context, '/panel');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ClientPanel()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text('Back to cart'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
          ),
          Expanded(
              flex: 9,
              child:
                  CartOrderList(context: context, orderList: widget.orderList)),
        ],
      ),
    );
  }
}
