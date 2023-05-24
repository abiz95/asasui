import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/CartService.dart';
import '../../services/LocalDataService.dart';
import '../ViewProductDetail.dart';
import '../dialogs/UpdateQuantityDialog.dart';

class CartOrderList extends StatefulWidget {
  var orderList;
  CartOrderList({Key? key, required context, required this.orderList})
      : super(key: key);

  @override
  State<CartOrderList> createState() => _CartOrderListState();
}

class _CartOrderListState extends State<CartOrderList> {
  bool linearProgressInd = false;

  String mode = 'view';
  Widget renderByteImage(img) {
    Uint8List image = base64Decode(img);
    // Image image = Image.memory(_image); // assign it value here
    return Image.memory(image);
  }

  Future<void> deleteProductFromCart(int orderId) async {
    var storeDetailResponse = await CartService().removeFromCart(orderId);
    print('deleteProductFromCart res body');
    print(storeDetailResponse.data['data'].toString());
    var test = storeDetailResponse.data['data'];
    if (storeDetailResponse.statusCode == 200) {
      // print('test obj');
      // print(test['productName']);
      // cartList = storeDetailResponse.data['data'];
      setState(() {
        widget.orderList = storeDetailResponse.data['data'];
        Provider.of<LocalDataService>(context, listen: false)
            .changeCartOrderList(widget.orderList);
        Provider.of<LocalDataService>(context, listen: false)
            .changeCartLinearLoader(false);
        // linearProgressInd = false;
      });
      // linearProgressInd = false;
      return storeDetailResponse.data['data'];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('cartordertest ${widget.orderList}');

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.orderList.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (BuildContext context, int index) {
        // print('snapshot value');
        // print(widget.orderList[index]);
        double c_width = MediaQuery.of(context).size.width * 0.20;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  padding: const EdgeInsets.all(8.0),
                  child: renderByteImage(widget.orderList[index]['productImg']),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Container(
                        width: c_width,
                        child: Text(
                          widget.orderList[index]['productName'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        "£ ${widget.orderList[index]['totalAmount']}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.black,
                  ),
                  tooltip: 'View product',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewProductDetail(
                              productDetail: widget.orderList[index],
                              mode: mode,
                            )));
                  },
                ),
                IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    tooltip: 'Remove',
                    onPressed: () async {
                      // setState(
                      //   () {
                      //     orderList = deleteProductFromCart(
                      //         orderList[index]['orderId']);
                      //   },
                      // );
                      // linearProgressInd = true;
                      setState(() {
                        linearProgressInd = true;
                      });
                      await deleteProductFromCart(
                          widget.orderList[index]['orderId']);
                      // orderListWidget(context);
                    }),
                GestureDetector(
                  // onTap: (() => updateQty(snapshot.data[index])),
                  onTap: (() => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => UpdateQuantity(
                            productDeatils: widget.orderList[index]),
                      )),
                  child: Container(
                    height: 30,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            '${widget.orderList[index]['orderQty']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
