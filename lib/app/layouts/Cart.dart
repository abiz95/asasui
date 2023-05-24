import 'package:asasui/app/layouts/ClientCheckoutDetail.dart';
import 'package:asasui/app/layouts/widgets/CartOrderList.dart';
import 'package:asasui/app/services/AuthService.dart';
import 'package:asasui/app/services/CartService.dart';
import 'package:flutter/material.dart';

import 'widgets/linearLoader.dart';
import 'widgets/loader.dart';

class Cart extends StatefulWidget {
  Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
// late int counter;
  // var cartList;
  bool linearProgressInd = false;
  bool errorMessageInd = false;
  var orderList;
  late final Future fetchCartListFuture;
  // String _scanBarcode = 'Unknown';
  Future<dynamic> fetchCartList() async {
    String clientId = await AuthService().decodeJwt('userId');
    var storeDetailResponse = await CartService().getCartList(clientId);
    // print('res body');
    // print(storeDetailResponse.data['data'].toString());
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

  @override
  void initState() {
    super.initState();
    fetchCartListFuture = fetchCartList();
    // setState(() {
    //   orderList = fetchCartList();
    // });
    // orderListWidget(context);
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

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.95;
    return FutureBuilder(
      future: fetchCartListFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Loader());
        } else if (snapshot.data.isNotEmpty) {
          orderList = snapshot.data;
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              orderList != null ?
              SizedBox(
                width: c_width,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.pushReplacementNamed(context, '/store', arguments: qrValue);
                    // Navigator.pushReplacementNamed(context, '/panel');
                    Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ClientCheckoutDetail(orderList: snapshot.data)));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Proceed to checkout'),
                ),
              ) : Container(),
              _linearProgressIndicator(),
              Expanded(
                  flex: 9,
                  child: CartOrderList(
                      context: context, orderList: snapshot.data)),
            ],
          );
        } else {
          return const Center(child: Text('No items in the cart!'));
        }
      },
    );
  }
}
