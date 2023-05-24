import 'dart:convert';
import 'dart:typed_data';

import 'package:asasui/app/layouts/widgets/MainAppBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../services/AuthService.dart';
import '../services/CartService.dart';
import '../services/RecommenderService.dart';
import '../services/StoreService.dart';
import 'ClientPanel.dart';
import 'widgets/BottomNavBar.dart';
import 'widgets/loader.dart';

class ViewProductDetail extends StatefulWidget {
  var productDetail;
  String mode;
  ViewProductDetail({Key? key, required this.productDetail, required this.mode})
      : super(key: key);

  @override
  State<ViewProductDetail> createState() => _ViewProductDetailState();
}

class _ViewProductDetailState extends State<ViewProductDetail> {
  var productData;
  var recommendationList;
  int counter = 1;
  bool viewUpdateBtnInd = false;
  late final Future setViewModeFuture;
  // late final Future fetchProductRecommendationFuture;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   orderList = fetchCartList();
    // });
    // orderListWidget(context);
    // setViewMode(widget.mode);
    setViewModeFuture = setViewMode(widget.mode);
  }

  Future<dynamic> setViewMode(String mode) async {
    switch (mode) {
      case 'view':
        {
          await fetchProductDetails(widget.productDetail['productId']);
          // fetchProductRecommendationFuture = await fetchProductRecommendation(
          //     productData['productType'], productData['productId']);
          await fetchProductRecommendation(
              productData['productType'], productData['productId']);
        }
        break;
      case 'scan':
        {
          productData = widget.productDetail;
          await fetchProductRecommendation(widget.productDetail['productType'],
              widget.productDetail['productId']);
        }
        break;
      default:
        {
          //statements;
          productData = null;
          widget.mode = 'null';
        }
        break;
    }
    print('view product mode: $mode');
    return productData;
  }

  Future<dynamic> fetchProductDetails(int productId) async {
    int? storeId = await StoreService().getStoreId();
    var storeDetailResponse =
        await CartService().getProductDetail(storeId!, productId);
    // print('fetchProductDetails res body');
    // print(storeDetailResponse.data['data'][0].toString());
    if (storeDetailResponse.statusCode == 200) {
      // print('test obj');
      // print(test['productName']);
      // cartList = storeDetailResponse.data['data'];
      // fetchProductRecommendationFuture = await fetchProductRecommendation(
      //     storeDetailResponse.data['data'][0]['productType'],
      //     storeDetailResponse.data['data'][0]['productId']);
      setState(() {
        productData = storeDetailResponse.data['data'][0];
        counter = widget.productDetail['orderQty'];
      });
      return storeDetailResponse.data['data'][0];
    } else {
      return null;
    }
  }

  Future fetchProductRecommendation(String productType, int productId) async {
    int? storeId = await StoreService().getStoreId();
    // print(
    //     'fetchProductRecommendation params prod type: $productType , id: $productId ');
    var storeDetailResponse = await RecommenderService()
        .getProductRecommendations(productType, productId, storeId!);
    // print('fetchProductRecommendation res body');
    // print(storeDetailResponse.data['data'][0].toString());
    if (storeDetailResponse.statusCode == 200) {
      // print('test obj');
      // print(test['productName']);
      // cartList = storeDetailResponse.data['data'];
      setState(() {
        recommendationList = storeDetailResponse.data['data'];
      });
      return storeDetailResponse.data['data'][0];
    } else {
      return null;
    }
  }

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
      // Provider.of<LocalDataService>(context, listen: false).changeQuantityDialog(true);
      // Navigator.pop(context, 'Update');
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

  Widget renderByteGridImage(img) {
    Uint8List image = base64Decode(img);
    // Image image = Image.memory(_image); // assign it value here
    return Image.memory(
      image,
      fit: BoxFit.fill,
    );
  }

  Widget quantityCounter() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              counter == 0 ? null : counter--;
              if (widget.mode == 'view') {
                setState(() {
                  viewUpdateBtnInd = true;
                });
              }
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
            '$counter',
            style: const TextStyle(color: Colors.white),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                null;
                counter++;
              });
              if (widget.mode == 'view') {
                setState(() {
                  viewUpdateBtnInd = true;
                });
              }
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
    );
  }

  //   Future<dynamic> updateQty(int orderId, int orderQty) async {
  //   // int? storeId = await StoreService().getStoreId();
  //   var storeDetailResponse =
  //       await CartService().updateProductQty(orderId, orderQty);
  //   print('updateQty res body');
  //   print(storeDetailResponse.data['data'].toString());
  //   var test = storeDetailResponse.data['data'];
  //   if (storeDetailResponse.statusCode == 200) {
  //     // print('test obj');
  //     // print(test['productName']);
  //     // cartList = storeDetailResponse.data['data'];
  //     Provider.of<LocalDataService>(context, listen: false).changeQuantityDialog(true);
  //     Navigator.pop(context, 'Update');
  //     return storeDetailResponse.data['data'];
  //   } else {
  //     return null;
  //   }
  // }

  Widget updateBtn() {
    if (viewUpdateBtnInd) {
      return ElevatedButton(
        onPressed: () async {
          // Respond to button press
          await updateQty(widget.productDetail['orderId'], counter);
        },
        style: OutlinedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text('Update order'),
      );
    } else {
      return Container();
    }
  }

  Future addProductToCart() async {
    // scanBarcodeNormal();
    String clientId = await AuthService().decodeJwt('userId');
    // var productDetails = await getProductDetails(_scanBarcode);
    print('addProductToCart');
    // print(productDetails.toString());
    DateTime currentDateTime = DateTime.now();
    String dateFormat =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(currentDateTime);
    print('addProductToCart date time');
    print(dateFormat);
    var formData = jsonEncode(<String, dynamic>{
      'clientId': clientId,
      'orderDate': dateFormat,
      'orderQty': counter,
      'orderStatus': 1,
      'paymentInt': 0,
      'productId': '${widget.productDetail['productId']}',
      'productPrice': '${widget.productDetail['price']}',
      'storeId': '${widget.productDetail['storeId']}',
      'storeLocationId': '${widget.productDetail['storeLocationId']}',
      'totalAmount': '${widget.productDetail['productPrice']}'
    });
    // var formData = <String, dynamic>{
    //   'clientId': clientId,
    //   'orderDate': 25,
    //   'orderQty': 1,
    //   'orderStatus': 1,
    //   'paymentInt': 0,
    //   'productId': '${productDetails[0]['productId']}',
    //   'productPrice': '${productDetails[0]['productPrice']}',
    //   'storeId': '${productDetails[0]['storeId']}',
    //   'storeLocationId': '${productDetails[0]['storeLocationId']}',
    //   'totalAmount': '${productDetails[0]['productPrice']}'
    // };
    var productSaveResp = await CartService().saveOrder(formData);
    // setState(() {
    //   orderList = productSaveResp.data['data'];
    //   Provider.of<LocalDataService>(context, listen: false)
    //       .changeCartOrderList(orderList);
    //   linearProgressInd = false;
    // });
    if (productSaveResp.statusCode == 200) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ClientPanel()));
    } else if (productSaveResp.statusCode == 201) {
      // print('resp for snackbar: ${productSaveResp.data['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${productSaveResp.data['message']}'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ClientPanel()));
    }

    // print("scanner data :: ${productSaveResp.data['data']}");
    // return productSaveResp.data['data'];
  }

  Widget addTocartBtn() {
    if (widget.mode == 'scan') {
      return SizedBox(
        width: 350,
        child: ElevatedButton(
          onPressed: () async {
            // Respond to button press
            await addProductToCart();
          },
          style: OutlinedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Add to cart'),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget productRecommendationCards() {
    return FutureBuilder(
      future: setViewModeFuture,
      initialData: recommendationList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Loader());
        } else if (snapshot.data.isNotEmpty) {
//           print('productRecommendationCards snapshot data ${snapshot.data}');
// print('productRecommendationCards first element ${snapshot.data['productName']}');
//           print('productRecommendationCards snapshot data ${snapshot.data.length}');
//           print('productRecommendationCards recommendationList ${recommendationList.length}');
          return Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Text(
                    'Recommendations',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  itemCount: recommendationList.length,
                  physics: const ScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return Card(
                      child: Container(
                        height: 290,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(5),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: renderByteGridImage(
                                      recommendationList[index]['productImg']),
                                ),
                                Text(
                                  '${recommendationList[index]['productName']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '£ ${recommendationList[index]['price']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Aisle number: ${recommendationList[index]['aisleNumber']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 5,
                    mainAxisExtent: 264,
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        } else {
          return const Center(child: Text('No items in the cart!'));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode != 'null') {
      return Scaffold(
        appBar: const MainAppBar(
          backOption: true,
        ),
        backgroundColor: const Color.fromARGB(245, 255, 227, 186),
        body: FutureBuilder(
          future: setViewModeFuture,
          initialData: productData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // print('test snapshot ${snapshot.data}');
            if (!snapshot.hasData) {
              return const Center(child: Loader());
            } else if (snapshot.data.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              productData['productName'],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                            renderByteImage(productData['productImg']),
                            Container(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Text(
                                  'Your deal: £${productData['price']}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                )),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: quantityCounter(),
                            ),
                            Container(
                                padding: EdgeInsets.only(bottom: 9.0),
                                child: const Text(
                                  'Description',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                )),
                            ReadMoreText(
                              '${productData['productDescription']}',
                              trimLines: 2,
                              colorClickableText: Colors.black,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                            ),
                          ],
                        ),
                      ),
                    ),
                    productRecommendationCards(),
                    Card(
                      child: ListTile(
                        title: const Text('Reviews'),
                        subtitle: Text(
                          'No reviews posted yet!',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    updateBtn(),
                    addTocartBtn(),
                  ],
                )),
              );
            } else {
              return const Center(child: Text('No items in the cart!'));
            }
          },
        ),
        bottomNavigationBar: BottomNavBar(),
      );
    } else {
      return const Center(
        child: Text('Product details unavailable'),
      );
    }
  }
}
