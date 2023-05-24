import 'dart:convert';

import 'package:asasui/app/layouts/widgets/MainAppBar.dart';
import 'package:flutter/material.dart';
// import 'package:pledge_frontend/app/services/AuthService.dart';

import '../models/AuthModel.dart';
import '../services/AuthService.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool errorMessageInd = false;
  bool loadingSpinnerInd = false;
  late String errorMessage = '';
  bool _passwordVisible = true;
  // Signin({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    errorMessageInd = false;
  }

  Widget _buildSignInForm() {
    String? _email;
    String? _password;
    double cardHeight = 460;
    double cardWidth = 500;
    var mediaQuerySize = MediaQuery.of(context).size;
    double deviceHeight = mediaQuerySize.height;
    double deviceWidth = mediaQuerySize.width;
    Orientation deviceOrientation = MediaQuery.of(context).orientation;
    print("height: $deviceHeight");
    print("width: $deviceWidth");
    print('deviceOrientation: ${deviceOrientation.name}');
    if (deviceOrientation.name == 'portrait') {
      print('object: small');
      if (mediaQuerySize.width < 500) {
        cardHeight = deviceHeight * 0.55;
        cardWidth = deviceWidth * 0.9;
      } else if(mediaQuerySize.width < 900) {
        cardHeight = deviceHeight * 0.35;
        cardWidth = deviceWidth * 0.9;
      } else {
        print('object: >500');
        cardHeight = deviceHeight * 0.90;
        cardWidth = deviceWidth * 0.9;
      }
    } else {
      print('object: large');
      if (mediaQuerySize.width < 500) {
        cardHeight = deviceHeight * 0.50;
        cardWidth = deviceWidth * 0.9;
      } else if(mediaQuerySize.width < 900) {
        print('object: <900');
        cardHeight = deviceHeight * 0.90;
        cardWidth = deviceWidth * 0.9;
      } else {
        print('object: >900');
        cardHeight = deviceHeight * 0.55;
        cardWidth = deviceWidth * 0.35;
      }
    }
    return Form(
      key: _formKey,
      child: Center(
        child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            height: cardHeight,
            width: cardWidth,
            // constraints:
            //     BoxConstraints(minHeight: height/4, maxHeight: height/2, minWidth: width*0.30, maxWidth: width*0.90),
            child: Card(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      // const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),
                      _errorMessageChip(),
                      TextFormField(
                        // The validator receives the text that the user has entered.
                        // controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                            labelStyle: TextStyle(color: Colors.green)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!RegExp(
                                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(value)) {
                            return 'Please enter a valid email Address';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          // _email = value;
                          setState(() {
                            _email = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            child: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.green),
                          ),
                          labelStyle: const TextStyle(color: Colors.green),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password field cannot be empty';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _password = value;
                        },
                        onSaved: (String? value) {
                          setState(() {
                            _password = value;
                          });
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        child:
                            // ElevatedButton.icon(
                            //     onPressed: () {
                            //       if (_formKey.currentState!.validate()) {
                            //         _formKey.currentState!.save();

                            //         signIUser(_email, _password);
                            //       }
                            //     },
                            //     icon: Icon(Icons.add),
                            //     label: Text('Sign In')),
                            ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              signInUser(_email, _password);
                              // Navigator.push(context, '/dashboard');
                              // Navigator.pushReplacementNamed(context, '/overview');
                            }
                            // Navigator.pushNamed(context, '/signup');
                          },
                          // child: const Text(
                          //   'Login',
                          //   style: TextStyle(fontSize: 16),
                          // ),
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
                                              AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      )));
                                } else {
                                  return const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16),
                                  );
                                }
                              }(),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 35, 97, 37)),
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
                    'Signup now',
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
                    ]),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const MainAppBar( backOption: false,),
      // appBar: AppBar(
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     // crossAxisAlignment: CrossAxisAlignment.center,
      //     children: const [
      //       Text(
      //         "Solemnly",
      //         style: TextStyle(fontFamily: 'Brush Script MT Italic', fontSize: 40),
      //       )
      //     ],
      //   ),
      //   automaticallyImplyLeading: false,
      //   backgroundColor: const Color.fromARGB(255, 35, 97, 37),
      // ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: _buildSignInForm()),
    );
  }

  Widget _errorMessageChip() {
    // print("param error message: $errorMessage");
    if (errorMessageInd == true) {
      return Container(
        margin: const EdgeInsets.all(10),
        child: InputChip(
          avatar: const Icon(Icons.error),
          label: Text(errorMessage),
          onSelected: (bool value) {},
          backgroundColor: const Color.fromARGB(255, 255, 179, 156),
        ),
      );
    }
    return Container();
  }

  //   @override
  // void initState() {
  //   super.initState();
  //   getAllPledgeData();
  // }

  void signInUser(String? email, String? password) async {
    // print("$email, $password");

    setState(() {
      errorMessageInd = false;
      loadingSpinnerInd = true;
    });

    var getUserLoginData = await AuthService().getToken();
    if (getUserLoginData['userid'].toString().isNotEmpty) {
      // print("logged In");
      AuthService().removeToken();
    }
    var getUserSigninRespose = await AuthService().signin(email, password);
    // Loader(str: getUserSigninRespose);
    print("code ${getUserSigninRespose.body}");
    print("json ${getUserSigninRespose.statusCode}");
    if (getUserSigninRespose.statusCode == 200) {
      AuthModel getUserSigninData =
          AuthModel.fromJson(jsonDecode(getUserSigninRespose.body));
      String? userSignInPayload = getUserSigninData.data as String;
      if (getUserSigninData.status == 200) {
        // print(getUserSigninData.Message);
        // await AuthService().saveLoginData(
        //     userSignInPayload[0]['userid'],
        //     userSignInPayload[0]['firstname'],
        //     userSignInPayload[0]['lastname'],
        //     userSignInPayload[0]['phonenumber'],
        //     userSignInPayload[0]['email'],
        //     userSignInPayload[0]['statusind'],
        //     userSignInPayload[0]['usertype']);
        await AuthService().saveToken(userSignInPayload);
        setState(() {
          loadingSpinnerInd = false;
        });
        Navigator.pushReplacementNamed(context, '/store');
      } else if (getUserSigninData.status == 401) {
        String? message = getUserSigninData.message;
        setState(() {
          errorMessage = 'Invalid Email or Password';
          // _buildChild('Invalid Email or Password');
          errorMessageInd = true;
          loadingSpinnerInd = false;
        });
      } else {
        setState(() {
          errorMessage = 'Something went wrong';
          // _buildChild('Something went wrong!');
          errorMessageInd = true;
          loadingSpinnerInd = false;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Something went wrong';
        // _buildChild('Something went wrong!');
        errorMessageInd = true;
        loadingSpinnerInd = false;
      });
    }
  }
}
