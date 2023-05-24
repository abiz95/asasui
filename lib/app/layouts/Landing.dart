import 'package:flutter/material.dart';


class Landing extends StatefulWidget {
  Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     // crossAxisAlignment: CrossAxisAlignment.center,
      //     children: const [
      //       Text(
      //         Constants.appName,
      //         style:
      //             TextStyle(fontFamily: 'Brush Script MT Italic', fontSize: 40),
      //       )
      //     ],
      //   ),
      //   backgroundColor: Color.fromARGB(255, 35, 97, 37),
      // ),
      backgroundColor: const Color.fromARGB(245, 255, 227, 186),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: SizedBox(
              child: Image(
                image: AssetImage('assets/images/shopping_bag.png'),
                height: 200,
              ),
            ),
          ),
          const Text(
            'Welcome',
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: const Text(
              'Enjoy the hassle free shopping experience with the state of the art checkout system',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {Navigator.pushNamed(context, '/signin');},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Sign in'), // <-- Text
                  SizedBox(
                    width: 25,
                  ),
                  Icon(
                    // <-- Icon
                    Icons.arrow_forward,
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: new Text(
                    'Sign up',
                    style: TextStyle(
                      color: Color(0xff132137),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
