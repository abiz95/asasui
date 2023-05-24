import 'dart:convert';
import 'dart:typed_data';

import 'package:asasui/app/layouts/ClientLogout.dart';
import 'package:asasui/app/services/AuthService.dart';
import 'package:asasui/app/services/ClientService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'widgets/linearLoader.dart';
import 'widgets/loader.dart';

class ClientProfile extends StatefulWidget {
  ClientProfile({Key? key}) : super(key: key);

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  bool linearProgressInd = false;
  bool errorMessageInd = false;
  late final Future fetchClientProfileDetailFuture;

  Future<dynamic> fetchClientProfileDetail() async {
    String clientId = await AuthService().decodeJwt('userId');
    var storeDetailResponse =
        await ClientService().getClientProfileDetail(clientId);
    print('fetchClientProfileDetail body');
    print(storeDetailResponse.data['data'].toString());
    print(storeDetailResponse.data['data'][0]['clientImage'].toString());
    var test = storeDetailResponse.data['data'];
    if (storeDetailResponse.statusCode == 200) {
      // print('test obj');
      // print(test['productName']);
      // cartList = storeDetailResponse.data['data'];
      // orderList = storeDetailResponse.data['data'];
      return storeDetailResponse.data['data'][0];
    } else {
      return null;
    }
  }

  Widget _linearProgressIndicator() {
    // _retriveUserData();
    if (linearProgressInd) {
      return const Center(
        child: LinearLoader(),
      );
    } else if (errorMessageInd) {
      return const Center(
        child: Text(
          'Error',
          style: TextStyle(color: Colors.red),
        ),
      );
    } else {
      return Container();
    }
  }

  String dateFormatter(int date) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  Widget renderByteImage(img) {
    Uint8List image = base64Decode(img);
    // Image image = Image.memory(_image); // assign it value here
    return Image.memory(image);
  }

  @override
  void initState() {
    super.initState();
    fetchClientProfileDetailFuture = fetchClientProfileDetail();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchClientProfileDetailFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('client snapshot :: ${snapshot.data}');
        if (!snapshot.hasData) {
          return const Center(child: Loader());
        } else if (snapshot.data.isNotEmpty) {
          return Column(
            children: [
              _linearProgressIndicator(),
              Expanded(
                  flex: 9,
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: ClipOval(
                                              child: renderByteImage(snapshot
                                                  .data['clientImage'])))),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Center(
                                    child: Text(
                                        '${snapshot.data['firstName']} ${snapshot.data['lastName']}'),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Center(
                                      child: Text('${snapshot.data['email']}')),
                                  const Divider(),
                                  const Text('Date of birth', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
                                  Text(dateFormatter(snapshot.data['dob'])),
                                  const Text('Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
                                  Text('${snapshot.data['address']}'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigator.pushReplacementNamed(context, '/store', arguments: qrValue);
                                      // Navigator.pushReplacementNamed(context, '/panel');
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClientLogout()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Card(
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Column(
                        //         children: [],
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  )),
            ],
          );
        } else {
          return const Center(child: Text('No items in the cart!'));
        }
      },
    );
  }
}
