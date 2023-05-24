import 'package:asasui/app/utils/Constants.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {

  final bool backOption;

  const MainAppBar({Key? key, required this.backOption}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              Constants.appName,
              style:
                  TextStyle(fontFamily: 'americorps', fontSize: 40),
            )
          ],
        ),
        automaticallyImplyLeading: backOption,
        backgroundColor: const Color.fromARGB(255, 35, 97, 37),
      );
  }
}