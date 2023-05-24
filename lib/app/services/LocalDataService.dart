import 'package:flutter/cupertino.dart';

class LocalDataService extends ChangeNotifier {
  bool updateQuantityDialogInd = false;
  int bottomNavIndex = 0;
  var orderList;
  bool cartLinearLoader = false;
  
  void changeQuantityDialog(bool event) {
    updateQuantityDialogInd = event;
    notifyListeners();
  }

  void changeBottomNavIndex(int index) {
    bottomNavIndex = index;
    notifyListeners();
  }

  void changeCartOrderList(var orderListParam) {
    orderList = orderListParam;
    notifyListeners();
  }

  void changeCartLinearLoader(bool cartLinearLoaderParam) {
    cartLinearLoader = cartLinearLoaderParam;
    notifyListeners();
  }
}
