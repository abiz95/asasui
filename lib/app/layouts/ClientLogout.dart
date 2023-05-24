import 'dart:async';

import 'package:asasui/app/services/AuthService.dart';
import 'package:asasui/app/services/StoreService.dart';
import 'package:flutter/material.dart';

import 'widgets/MainAppBar.dart';

class ClientLogout extends StatefulWidget {
  ClientLogout({Key? key}) : super(key: key);

  @override
  State<ClientLogout> createState() => _ClientLogoutState();
}

class _ClientLogoutState extends State<ClientLogout> {
  Future<void> removeToken() async {
    await AuthService().removeToken();
    await StoreService().removeStoreId();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    removeToken();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/');
    });
    return Scaffold(
      appBar: const MainAppBar(
        backOption: false,
      ),
      backgroundColor: const Color.fromARGB(245, 255, 227, 186),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('You have been logged out. You will be redirected to home in 5 seconds.'),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: SizedBox(
                width: 1000,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.pushReplacementNamed(context, '/store', arguments: qrValue);
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Sign In'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
