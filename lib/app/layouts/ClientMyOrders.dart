import 'package:asasui/app/layouts/ViewBillingDetail.dart';
import 'package:asasui/app/services/OrderService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/AuthService.dart';
import 'widgets/loader.dart';

class ClientMyOrders extends StatefulWidget {
  ClientMyOrders({Key? key}) : super(key: key);

  @override
  State<ClientMyOrders> createState() => _ClientMyOrdersState();
}

class _ClientMyOrdersState extends State<ClientMyOrders> {
  bool linearProgressInd = false;
  bool errorMessageInd = false;
  late final Future fetchClientBillListFuture;

  Future<dynamic> fetchClientBillList() async {
    String clientId = await AuthService().decodeJwt('userId');
    var storeDetailResponse = await OrderService().getClientBillList(clientId);
    print('fetchClientProfileDetail body');
    print(storeDetailResponse.data['data'].toString());
    // print(storeDetailResponse.data['data'][0]['clientImage'].toString());
    var test = storeDetailResponse.data['data'];
    if (storeDetailResponse.statusCode == 200) {
      // print('test obj');
      // print(test['productName']);
      // cartList = storeDetailResponse.data['data'];
      // orderList = storeDetailResponse.data['data'];
      return storeDetailResponse.data['data'];
    } else {
      return null;
    }
  }

  String dateFormatter(int date) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  @override
  void initState() {
    super.initState();
    fetchClientBillListFuture = fetchClientBillList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchClientBillListFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Loader());
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              // print('fetchClientBillList list: ${snapshot.data}');
              if (snapshot.data.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    color: Color.fromARGB(255, 22, 158, 26)),
                                Text(
                                    'Bill number: ${snapshot.data[index]['billingId']}'),
                              ],
                            ),
                            Text(
                                'Date: ${dateFormatter(snapshot.data[index]['orderDate'])}')
                          ],
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            // Respond to button press
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ViewBillingDetail(
                                    billingId: snapshot.data[index]
                                        ['billingId'])));
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined,
                              size: 18),
                          label: const Text("View"),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green),
                        )
                      ],
                    ),
                  )),
                );
              } else {
                return const Center(child: Text('No bills!'));
              }
            },
          );
        }
      },
    );
  }
}
