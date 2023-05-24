import 'package:asasui/app/layouts/widgets/MainAppBar.dart';
import 'package:asasui/app/services/StoreService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Store extends StatefulWidget {
  Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  late int qrValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? storeIdFormVal;

  bool loadingSpinnerInd = false;
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      qrValue = int.parse(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    //   qrValue = barcodeScanRes;
    // });
    await saveStoreId(qrValue);
  }

  Future<void> saveStoreId(int storeId) async {
    await StoreService().saveStoreId(storeId);
    print('qrvalue:  $storeId');
    Navigator.pushReplacementNamed(context, '/store/details');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        backOption: false,
      ),
      backgroundColor: const Color.fromARGB(245, 255, 227, 186),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      child: Text('Scan QR code for store'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          await scanQR();
                        },
                        child: const Text('Scan QR'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: const Divider(),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: const Text('Enter store code'),
                    ),
                    // const SizedBox(
                    //   child: Text('Enter store code'),
                    // ),
                    Form(
                        key: _formKey,
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: TextFormField(
                                  // The validator receives the text that the user has entered.
                                  // controller: _emailController,
                                  decoration: const InputDecoration(
                                      labelText: 'Store Id',
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.green)),
                                      labelStyle:
                                          TextStyle(color: Colors.green)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please the store Id';
                                    }
                                    return null;
                                  },
                                  onSaved: (var value) {
                                    setState(() {
                                      storeIdFormVal = int.parse(value!);
                                    });
                                  },
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    saveStoreId(storeIdFormVal!);
                                    // signInUser(_email, _password);
                                  }
                                  // Navigator.pushNamed(context, '/signup');
                                },
                                style: ElevatedButton.styleFrom(
                                    primary:
                                        const Color.fromARGB(255, 35, 97, 37)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    () {
                                      if (loadingSpinnerInd == true) {
                                        return const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                              Colors.white,
                                            )));
                                      } else {
                                        return const Text(
                                          'Proceed',
                                          style: TextStyle(fontSize: 16),
                                        );
                                      }
                                    }(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
