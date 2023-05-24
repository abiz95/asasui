import 'dart:convert';

import 'package:asasui/app/layouts/widgets/loader.dart';
import 'package:asasui/app/models/ResponseModel.dart';
import 'package:asasui/app/services/StoreService.dart';
import 'package:flutter/material.dart';

import 'widgets/MainAppBar.dart';

class StoreDetail extends StatefulWidget {
  StoreDetail({Key? key}) : super(key: key);

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  List? storeData;
  Future<dynamic> fetchStoreDetails() async {
    int? storeId = await StoreService().getStoreId();
    var storeDetailResponse = await StoreService().getStoreDetails(storeId);
    print('res body');
    print(storeDetailResponse.data['data'][0].toString());
    var test = storeDetailResponse.data['data'][0];
    if (storeDetailResponse.statusCode == 200) {
      print('test obj');
      print(test['storeName']);
      return storeDetailResponse.data['data'][0];
    } else {
      return null;
    }

    // ResponseModel storeData =
    //     ResponseModel.fromJson(jsonDecode(storeDetailResponse.data));
    // print("fetechClientDetails: ${storeData.data}");
    // if (storeData.status == 200) {}
  }

  // Future<Widget> storeDetails() async {
  //   var details = await fetchStoreDetails();
  //   if (details != null) {
  //     return Column(
  //       children: [Text('$details.storeName')],
  //     );
  //   } else {
  //     return Column(
  //       children: [
  //         const Text('Something went wrong. Please the scan the QR again'),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pushNamed(context, '/store');
  //           },
  //           child: const Text('Scan QR'),
  //         )
  //       ],
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        backOption: false,
      ),
      backgroundColor: const Color.fromARGB(245, 255, 227, 186),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            child: Text(
              'Store details',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
              child: FutureBuilder(
            future: fetchStoreDetails(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Loader());
              } else if (snapshot.data.isNotEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data['storeName'],
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          snapshot.data['storeLocationName'],
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: Colors.black45,
                          ),
                        ),
                        Text(snapshot.data['storeLocationaddress']),
                        // FutureBuilder(
                        //   future: fetchStoreDetails(),
                        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                        //     if (!snapshot.hasData) {
                        //       return const Loader();
                        //     }
                        //     else {
                        //       final displayName = snapshot.data['storeName'];
                        //       return Column(
                        //         children: [
                        //           Text(snapshot.data['storeName'])
                        //         ],
                        //       );
                        //     }
                        //   },
                        // ),
                        // storeDetails(),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.pushReplacementNamed(context, '/store', arguments: qrValue);
                              Navigator.pushReplacementNamed(context, '/panel');
                            },
                            child: const Text('Continue'),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Divider(
                              height: 10,
                              thickness: 2,
                              indent: 20,
                              endIndent: 0,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        const SizedBox(
                          child: Text('If the address is wrong scan again'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/store');
                          },
                          child: const Text('Scan QR'),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    const Text(
                        'Something went wrong. Please the scan the QR again'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/store');
                      },
                      child: const Text('Scan QR'),
                    ),
                  ],
                );
              }
              // if (!snapshot.hasData) {
              //   return const Loader();
              // } else {
              //   return Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           const SizedBox(
              //             child: Text('Store details'),
              //           ),
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           Text(snapshot.data['storeName']),
              //           Text(snapshot.data['storeLocationName']),
              //           Text(snapshot.data['storeLocationaddress']),
              //           // FutureBuilder(
              //           //   future: fetchStoreDetails(),
              //           //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //           //     if (!snapshot.hasData) {
              //           //       return const Loader();
              //           //     }
              //           //     else {
              //           //       final displayName = snapshot.data['storeName'];
              //           //       return Column(
              //           //         children: [
              //           //           Text(snapshot.data['storeName'])
              //           //         ],
              //           //       );
              //           //     }
              //           //   },
              //           // ),
              //           // storeDetails(),
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           SizedBox(
              //             height: 40,
              //             child: ElevatedButton(
              //               onPressed: () {
              //                 // Navigator.pushReplacementNamed(context, '/store', arguments: qrValue);
              //                 Navigator.pushReplacementNamed(context, '/store');
              //               },
              //               child: const Text('Cart'),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   );
              // }
            },
          )),
        ],
      ),
    );
  }
}
