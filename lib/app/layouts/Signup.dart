import 'dart:convert';

import 'package:asasui/app/models/AuthModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/UserModel.dart';
import '../services/AuthService.dart';
import 'widgets/MainAppBar.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool errorMessageInd = false;
  bool loadingSpinnerInd = false;
  late String errorMessage = '';
  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;

  final GlobalKey<FormState> _signUpForm = GlobalKey<FormState>();
  // DateTime selectedDate = DateTime.now();

    String? firstName;
    String? lastName;
    String? dob;
    String? email;
    String? password;
    String? address;
    String? confirmPassword;
    String? phoneNumber;
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmpasswordController = TextEditingController();
    TextEditingController dobController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // errorMessageInd = false;
  }

  Future<dynamic> dateSelector() async {
                  DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(
                      1900), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101));

              if (pickedDate != null) {
                print('pickedDate $pickedDate'); //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                print('formattedDate $formattedDate'); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

                setState(() {
                  dobController.text =
                      formattedDate; //set output date to TextField value.
                      dob=formattedDate;
                });
              } else {
                print("Date is not selected");
              }
  }

  Widget _buildSignUpForm() {

    return Form(
      key: _signUpForm,
      child:
          // Center(
          //   child:
          Column(children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            // The validator receives the text that the user has entered.
            // controller: _emailController,
            decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                labelStyle: TextStyle(color: Colors.green)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
            onSaved: (String? value) {
              // _email = value;
              setState(() {
                firstName = value;
              });
              // print("ON SAVED EMAIL: $_email");
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            // The validator receives the text that the user has entered.
            // controller: _emailController,
            decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                labelStyle: TextStyle(color: Colors.green)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
            onSaved: (String? value) {
              // _email = value;
              setState(() {
                lastName = value;
              });
              // print("ON SAVED EMAIL: $_email");
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            controller: dobController, //editing controller of this TextField
            decoration: const InputDecoration(
                labelText: 'Date of birth',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                labelStyle: TextStyle(color: Colors.green)),
            readOnly:
                true, //set it true, so that user will not able to edit text
            onTap: () async {

              await dateSelector();

              // DateTime? pickedDate = await showDatePicker(
              //     context: context,
              //     initialDate: DateTime.now(),
              //     firstDate: DateTime(
              //         1900), //DateTime.now() - not to allow to choose before today.
              //     lastDate: DateTime(2101));

              // if (pickedDate != null) {
              //   print('pickedDate $pickedDate'); //pickedDate output format => 2021-03-10 00:00:00.000
              //   String formattedDate =
              //       DateFormat('yyyy-MM-dd').format(pickedDate);
              //   print('formattedDate $formattedDate'); //formatted date output using intl package =>  2021-03-16
              //   //you can implement different kind of Date Format here according to your requirement

              //   setState(() {
              //     dobController.text =
              //         formattedDate; //set output date to TextField value.
              //         dob=formattedDate;
              //   });
              // } else {
              //   print("Date is not selected");
              // }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your date of birth';
              }
              return null;
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
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
                email = value;
              });
              // print("ON SAVED EMAIL: $_email");
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            // The validator receives the text that the user has entered.
            // controller: _emailController,
            decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                labelStyle: TextStyle(color: Colors.green)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            onSaved: (String? value) {
              // _email = value;
              setState(() {
                phoneNumber = value;
              });
              // print("ON SAVED EMAIL: $_email");
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            // The validator receives the text that the user has entered.
            // controller: _emailController,
            decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                labelStyle: TextStyle(color: Colors.green)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
            onSaved: (String? value) {
              // _email = value;
              setState(() {
                address = value;
              });
              // print("ON SAVED EMAIL: $_email");
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
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
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
              password = value;
            },
            onSaved: (String? value) {
              setState(() {
                password = value;
              });
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            obscureText: _confirmPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Confirm password',
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _confirmPasswordVisible = !_confirmPasswordVisible;
                  });
                },
                child: Icon(
                    _confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.green),
              ),
              labelStyle: const TextStyle(color: Colors.green),
            ),
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirm password field cannot be empty';
              }
              return null;
            },
            onChanged: (value) {
              confirmPassword = value;
            },
            onSaved: (String? value) {
              setState(() {
                confirmPassword = value;
              });
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_signUpForm.currentState!.validate()) {
              _signUpForm.currentState!.save();
              userRegistration(firstName, lastName, email, password,
                  phoneNumber, address, dob);
              // signInUser(_email, _password);
            }
            // Navigator.pushNamed(context, '/signup');
          },
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      )));
                } else {
                  return const Text(
                    'Register',
                    style: TextStyle(fontSize: 16),
                  );
                }
              }(),
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 35, 97, 37)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already a member? ',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/signin');
                },
                child: new Text(
                  'Log In',
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
      // ),
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double cardHeight = 700;
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
        cardHeight = deviceHeight * 0.99;
        cardWidth = deviceWidth * 0.9;
      } else if (mediaQuerySize.width < 900) {
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
        cardHeight = deviceHeight * 0.99;
        cardWidth = deviceWidth * 0.9;
      } else if (mediaQuerySize.width < 900) {
        print('object: <900');
        cardHeight = deviceHeight * 0.99;
        cardWidth = deviceWidth * 0.9;
      } else {
        print('object: >900');
        cardHeight = deviceHeight * 0.99;
        cardWidth = deviceWidth * 0.35;
      }
    }

    return Scaffold(
      appBar: const MainAppBar(
        backOption: false,
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child:
              // Center(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              // children: [
              // child:
              Center(
            child: Container(
              height: cardHeight,
              width: cardWidth,
              margin: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 10),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        _errorMessageChip(),
                        Container(
                            padding: const EdgeInsets.all(15),
                            child: _buildSignUpForm()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          // _buildSignUpForm()
          // ],
          // )
          ),
    );
  }

  void userRegistration(
      String? firstName,
      String? lastName,
      String? email,
      String? password,
      String? phoneNumber,
      String? address,
      String? dob) async {
    // print("$email, $password");

    setState(() {
      errorMessageInd = false;
      loadingSpinnerInd = true;
    });

    // Navigator.pushReplacementNamed(context, '/profile/image/upload');

    var getUserLoginData = await AuthService().getToken();
    if (getUserLoginData['userid'].toString().isNotEmpty) {
      // print("logged In");
      AuthService().removeToken();
    }

    var getResgistrationRespose = await AuthService().signUp(
        firstName, lastName, email, password, phoneNumber, address, dob);
    print("getResgistrationRespose: ${getResgistrationRespose.body}");
    if (getResgistrationRespose.statusCode == 200) {
      AuthModel getUserRegistrationData =
          AuthModel.fromJson(jsonDecode(getResgistrationRespose.body));
      String? userRegistrationPayload = getUserRegistrationData.data as String;
      if (getUserRegistrationData.status == 200) {
        // print(getUserSigninData.Message);
        // await AuthService().saveLoginData(
        //     userSignInPayload[0]['userid'],
        //     userSignInPayload[0]['firstname'],
        //     userSignInPayload[0]['lastname'],
        //     userSignInPayload[0]['phonenumber'],
        //     userSignInPayload[0]['email'],
        //     userSignInPayload[0]['statusind'],
        //     userSignInPayload[0]['usertype']
        //     );
        // String? userSignInPayload = getUserSigninData.data as String;
        await AuthService().saveToken(userRegistrationPayload);
        setState(() {
          loadingSpinnerInd = false;
        });
        Navigator.pushReplacementNamed(context, '/profile/image/upload');
      } else if (getUserRegistrationData.status == 401) {
        String? message = getUserRegistrationData.message;
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
