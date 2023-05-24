import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../services/CartService.dart';
import '../dialogs/UpdateQuantityDialog.dart';

class OrderCard extends StatefulWidget {
  var orderList;
  late int index;
  var c_width;
  late bool linearProgressInd;
  OrderCard({Key? key, required orderList, required index, required c_width, linearProgressInd}) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {

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
        widget.linearProgressInd = false;
      });
      // linearProgressInd = false;
      return storeDetailResponse.data['data'];
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
  Widget build(BuildContext context) {
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
                  child: renderByteImage(widget.orderList[widget.index]['productImg']),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Container(
                        width: widget.c_width,
                        child: Text(
                          widget.orderList[widget.index]['productName'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        "£ ${widget.orderList[widget.index]['totalAmount']}",
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
                  onPressed: () {},
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
                        widget.linearProgressInd = true;
                      });
                      await deleteProductFromCart(widget.orderList[widget.index]['orderId']);
                      // orderListWidget(context);
                    }),
                GestureDetector(
                  // onTap: (() => updateQty(snapshot.data[index])),
                  onTap: (() => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) =>
                            UpdateQuantity(productDeatils: widget.orderList[widget.index]),
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
                            '${widget.orderList[widget.index]['orderQty']}',
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
  }
}