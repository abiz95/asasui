import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/CartService.dart';
import '../../services/LocalDataService.dart';
import '../../services/StoreService.dart';

class UpdateQuantity extends StatefulWidget {
    var productDeatils;
  UpdateQuantity({Key? key, required this.productDeatils}) : super(key: key);
  int counter = 0;

  @override
  State<UpdateQuantity> createState() => _UpdateQuantityState();
}

class _UpdateQuantityState extends State<UpdateQuantity> {
  Future<dynamic> updateQty(int orderId, int orderQty) async {
    // int? storeId = await StoreService().getStoreId();
    var storeDetailResponse =
        await CartService().updateProductQty(orderId, orderQty);
    print('updateQty res body');
    print(storeDetailResponse.data['data'].toString());
    var test = storeDetailResponse.data['data'];
    if (storeDetailResponse.statusCode == 200) {
      // print('test obj');
      // print(test['productName']);
      // cartList = storeDetailResponse.data['data'];
      Provider.of<LocalDataService>(context, listen: false).changeQuantityDialog(true);
      Navigator.pop(context, 'Update');
      return storeDetailResponse.data['data'];
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      widget.counter = widget.productDeatils['orderQty'];
    });
  }

  Widget renderByteImage(img) {
    Uint8List image = base64Decode(img);
    // Image image = Image.memory(_image); // assign it value here
    return Image.memory(image);
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.20;

    return AlertDialog(
      title: const Text('Update Quantity'),
      content: IntrinsicHeight(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    padding: const EdgeInsets.all(8.0),
                    child: renderByteImage(widget.productDeatils['productImg']),
                  ),
                  Expanded(
                    flex: 6,
                    child: SizedBox(
                      width: c_width,
                      child: Text(
                        widget.productDeatils['productName'],
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: const Text('Quantity')),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.green,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          widget.counter == 0 ? null : widget.counter--;
                        }),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        '${widget.counter}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            null;
                            widget.counter++;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await updateQty(widget.productDeatils['orderId'], widget.counter);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
