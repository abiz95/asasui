import 'package:asasui/app/layouts/Cart.dart';
import 'package:asasui/app/layouts/widgets/BottomNavBar.dart';
import 'package:asasui/app/layouts/widgets/ProductScanner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/LocalDataService.dart';
import 'ClientMyOrders.dart';
import 'ClientProfile.dart';
import 'widgets/MainAppBar.dart';

class ClientPanel extends StatefulWidget {
  ClientPanel({Key? key}) : super(key: key);

  @override
  State<ClientPanel> createState() => _ClientPanelState();
}

class _ClientPanelState extends State<ClientPanel> {
  final screens = [
    Cart(),
    ClientMyOrders(),
    ClientProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        backOption: false,
      ),
      backgroundColor: const Color.fromARGB(245, 255, 227, 186),
      body: screens[Provider.of<LocalDataService>(context).bottomNavIndex],
      floatingActionButton: ProductScanner(),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
