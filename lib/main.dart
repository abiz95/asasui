import 'package:asasui/app/layouts/Cart.dart';
import 'package:asasui/app/layouts/ClientDocumentUpload.dart';
import 'package:asasui/app/layouts/ClientPanel.dart';
import 'package:asasui/app/layouts/ClientProfileImageUpload.dart';
import 'package:asasui/app/layouts/Store.dart';
import 'package:asasui/app/layouts/StoreDetail.dart';
import 'package:asasui/app/services/LocalDataService.dart';
import 'package:asasui/app/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/layouts/Landing.dart';
import 'app/layouts/signin.dart';
import 'app/layouts/signup.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => LocalDataService(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => Landing(),
        '/signin': (context) => Signin(),
        '/signup': (context) => SignUp(),
        '/panel': (context) => ClientPanel(),
        '/cart': (context) => Cart(),
        '/store': (context) => Store(),
        '/store/details': (context) => StoreDetail(),
        '/profile/image/upload': (context) => ClientProfileImageUpload(),
        '/verification/document/upload': (context) => ClientDocumentUpload(),
        // '/logout': (context) => const Logout(),
        // '/create': (context) => CreatePledge(),
        // '/PledgeView': (context) => PledgeView(),
      },
    );
  }
}
