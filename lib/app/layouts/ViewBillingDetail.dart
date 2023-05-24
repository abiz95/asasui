import 'dart:convert';
import 'dart:typed_data';

import 'package:asasui/app/services/OrderService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'widgets/BottomNavBar.dart';
import 'widgets/MainAppBar.dart';
import 'widgets/loader.dart';

class ViewBillingDetail extends StatefulWidget {
  String billingId;
  ViewBillingDetail({Key? key, required this.billingId}) : super(key: key);

  @override
  State<ViewBillingDetail> createState() => _ViewBillingDetailState();
}

class _ViewBillingDetailState extends State<ViewBillingDetail> {
  late final Future fetchProductDetailsFuture;
  var billingData;
  var billAmtDetail;
  Future<dynamic> fetchBillingDetails(String billingId) async {
    // int? storeId = await StoreService().getStoreId();
    var billSummaryResponse = await OrderService().getBillSummary(billingId);
    // print('[ViewBillingDetail] fetchProductDetails res body');
    // print(billSummaryResponse.data['data'][0].toString());
    if (billSummaryResponse.statusCode == 200) {
      // print('test obj');
      // print(test['productName']);
      // cartList = storeDetailResponse.data['data'];
      setState(() {
        billingData = billSummaryResponse.data['data'];
      });
      return billSummaryResponse.data['data'];
    } else {
      return null;
    }
  }

  Future<dynamic> fetchBillingAmtDetails(String billingId) async {
    // int? storeId = await StoreService().getStoreId();
    var billAmountResponse =
        await OrderService().getBillAmountDetail(billingId);
    print('[ViewBillingDetail] fetchBillingAmtDetails res body');
    print(billAmountResponse.data['data'].toString());
    if (billAmountResponse.statusCode == 200) {
      // print('test obj');
      print('fetchBillingAmtDetails ${billAmountResponse.data['data'][0]}');
      // cartList = storeDetailResponse.data['data'];
      setState(() {
        billAmtDetail = billAmountResponse.data['data'][0];
      });
      return billAmountResponse.data['data'][0];
    } else {
      return null;
    }
  }

  Widget renderByteImage(img) {
    Uint8List image = base64Decode(img);
    // Image image = Image.memory(_image); // assign it value here
    return Image.memory(image);
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetailsFuture = fetchBillingDetails(widget.billingId);
    fetchBillingAmtDetails(widget.billingId);
  }

  String dateFormatter(int date) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        backOption: true,
      ),
      backgroundColor: const Color.fromARGB(245, 255, 227, 186),
      body: FutureBuilder(
        future: fetchProductDetailsFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // print('ViewBillingDetail snapshot data ${billingData}');
          if (billingData == null) {
            return const Center(child: Loader());
          } else if (billingData.isNotEmpty) {
            double cWidth = MediaQuery.of(context).size.width * 0.35;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 1000,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Billing Details',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text('${billAmtDetail['storeName']}',
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Text('${billAmtDetail['storeLocationName']}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Billing Id: ${billAmtDetail['billingId']}'),
                            Text(
                                'Billing date: ${dateFormatter(billAmtDetail['billDate'])}'),
                            Text(
                                'Billing amount: £ ${billAmtDetail['billingAmount']}'),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: billingData!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Column(
                          children: [
                            // Card(
                            //   child: Text(billingData[index]['productName']),
                            // )
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      padding: const EdgeInsets.all(8.0),
                                      child: renderByteImage(
                                          billingData[index]['productImg']),
                                    ),
                                    SizedBox(
                                      child: Container(
                                        width: cWidth,
                                        child: Text(
                                          billingData[index]['productName'],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Text(
                                        "Quantity: ${billingData[index]['orderQty']}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Text(
                                        "£ ${billingData[index]['totalAmount']}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No items in the cart!'));
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
