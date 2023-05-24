import 'dart:convert';

import 'package:asasui/app/layouts/ViewProductDetail.dart';
import 'package:asasui/app/layouts/dialogs/CommonDialog.dart';
import 'package:asasui/app/layouts/widgets/loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../services/AuthService.dart';
import '../../services/CartService.dart';
import '../../services/LocalDataService.dart';
import '../../services/StoreService.dart';
import 'CartOrderList.dart';

class ProductScanner extends StatefulWidget {
  ProductScanner({Key? key}) : super(key: key);

  @override
  State<ProductScanner> createState() => _ProductScannerState();
}

class _ProductScannerState extends State<ProductScanner> {
  bool linearProgressInd = false;
  bool errorMessageInd = false;
  var orderList;
  String _scanBarcode = 'Unknown';

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    print('Barcode value: $barcodeScanRes');
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    // addProductToCart(barcodeScanRes);
    return getProductDetails(barcodeScanRes);
  }

  Future<void> getProductDetails(String productBarcode) async {
    try {
    int? storeId = await StoreService().getStoreId();
    String clientId = await AuthService().decodeJwt('userId');
    print(
        'storeId: $storeId,productBarcode: $productBarcode, clientId: $clientId');
    var storeDetailResponse = await CartService()
        .getProductDetailFromBarcode(storeId!, productBarcode, clientId);
    print('getProductDetails res body');
    print(storeDetailResponse.data.toString());
    var test = storeDetailResponse.data['data'];
    if (storeDetailResponse.statusCode == 200) {
      // print('test obj');
      // print(test['productName']);
      // cartList = storeDetailResponse.data['data'];
      print(' scan status message: ${storeDetailResponse.data['message']}');
      productDetailRoute(storeDetailResponse.data['data'][0]);
      // return storeDetailResponse.data['data'][0];
    } else if (storeDetailResponse.statusCode == 201) {
      // return null;
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => CommonDialog(
            dialogName: 'productAgeRestriction',
            message: storeDetailResponse.data['message'], dialogTitle: 'Failed',),
      );
    }
    }on DioError catch (e) {
      print('getProductDetails exception ${e}');
            // print('getProductDetails exception ${e.response?.extra }');
            //       print('getProductDetails exception ${e.response?.headers }');
            //             print('getProductDetails exception ${e.response?.requestOptions }');
            //                   print('getProductDetails exception ${e.response?.statusMessage }');
      
    }

  }

  // Widget popupMessage() {
  //   return
  // }

  productDetailRoute(var storeDetailResponse) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ViewProductDetail(
            productDetail: storeDetailResponse, mode: 'scan')));
  }

  // Future<dynamic> addProductToCart() async {
  //   scanBarcodeNormal();
  //   String clientId = await AuthService().decodeJwt('userId');
  //   var productDetails = await getProductDetails(_scanBarcode);
  //   print('addProductToCart');
  //   print(productDetails.toString());
  //   DateTime currentDateTime = DateTime.now();
  //   String dateFormat =
  //       DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(currentDateTime);
  //   print('addProductToCart date time');
  //   print(dateFormat);
  //   var formData = jsonEncode(<String, dynamic>{
  //     'clientId': clientId,
  //     'orderDate': dateFormat,
  //     'orderQty': 1,
  //     'orderStatus': 1,
  //     'paymentInt': 0,
  //     'productId': '${productDetails[0]['productId']}',
  //     'productPrice': '${productDetails[0]['price']}',
  //     'storeId': '${productDetails[0]['storeId']}',
  //     'storeLocationId': '${productDetails[0]['storeLocationId']}',
  //     'totalAmount': '${productDetails[0]['productPrice']}'
  //   });
  //   var productSaveResp = await CartService().saveOrder(formData);
  //   setState(() {
  //     orderList = productSaveResp.data['data'];
  //     Provider.of<LocalDataService>(context, listen: false)
  //         .changeCartOrderList(orderList);
  //     linearProgressInd = false;
  //   });
  //   print("scanner data :: ${productSaveResp.data['data']}");
  //   return productSaveResp.data['data'];
  // }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        // Add your onPressed code here!
        // await scanBarcodeNormal();
        // await addProductToCart(_scanBarcode);
        // orderListWidget(context);
        setState(() {
          linearProgressInd = true;
        });
        FutureBuilder(
          future: scanBarcodeNormal(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print('FloatingActionButton res');
            print(snapshot.data);
            if (!snapshot.hasData) {
              return const Center(child: Loader());
            } else if (snapshot.data.isNotEmpty) {
              // return CartOrderList(context: context, orderList: snapshot.data);
              // return productDetailRoute(snapshot.data);
              return Container();
            } else {
              return const Center(
                  child: Text('Something went wrong. Please try again!'));
            }
          },
        );
      },
      label: const Text('Scan'),
      icon: const Icon(Icons.camera),
      backgroundColor: Colors.green,
    );
  }
}
