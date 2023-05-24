import 'package:flutter/material.dart';
import 'dart:async';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
      Colors.green,
    ));
  }
}
