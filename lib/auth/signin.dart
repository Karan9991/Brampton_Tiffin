import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiffin/auth/signup.dart';
import 'package:tiffin/home_screens/home.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tiffin/util/app_constants.dart';
import 'package:tiffin/util/snackbar.dart';
import 'package:tiffin/util/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  bool _rememberMe = false;
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          child: Container(
            height: 1000,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage('assets/image/t2.jpg'),
                fit: BoxFit.fitWidth,
              ),
            ), //

            child: Container(
              margin: EdgeInsets.only(top: 210),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                // color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),

              //here i want  container somehow
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontStyle: FontStyle.normal,
                        fontFamily: GoogleFonts.abhayaLibre().fontFamily),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 40, left: 10, right: 10),
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              ),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return "Enter a valid Email Address";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required';
                              }

                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _password = value;
                            },
                          ),
                          Row(
                            children: [
                              Container(
                                height: 20,
                                child: Row(children: [
                                  Theme(
                                    data: ThemeData(
                                      checkboxTheme: CheckboxThemeData(
                                        fillColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.selected)) {
                                              return Theme.of(context)
                                                  .primaryColor;
                                            }
                                            return Theme.of(context)
                                                .primaryColor; // default color of the square box
                                          },
                                        ),
                                      ),
                                    ),
                                    child: Checkbox(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    'Remember Me',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ]),
                              ),

                              // Container(
                              //   height: 20,
                              //   child: Row(children: [
                              //     Checkbox(
                              //       shape: RoundedRectangleBorder(
                              //           side: BorderSide(
                              //               color: Theme.of(context)
                              //                   .primaryColor)),
                              //       value: _rememberMe,
                              //       onChanged: (value) {
                              //         setState(() {
                              //           _rememberMe = value!;
                              //         });
                              //       },
                              //       checkColor: Colors
                              //           .green, // set the color of the square box
                              //     ),
                              //     Text('Remember Me',
                              //         style: TextStyle(
                              //           color: Theme.of(context).primaryColor,
                              //         )),
                              //   ]),
                              // ),
                              SizedBox(
                                height: 30,
                                width: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (!_globalKey.currentState!.validate()) {
                                return;
                              }

                              _globalKey.currentState!.save();
                              loginWithEmail(_emailController.text,
                                  _passwordController.text);
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              minimumSize: Size(double.infinity, 50.0),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Don\'t have an account? ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> saveUser(
      Map<String, dynamic> userMap, String token) async {
    await SharedPrefHelper.init();
    await SharedPrefHelper.setInt('id', userMap['id']);
    await SharedPrefHelper.setString('email', userMap['email']);
    await SharedPrefHelper.setString('userType', userMap['user_type']);
    await SharedPrefHelper.setString('token', token);
  }

  static Future<Map<String, dynamic>> getUser() async {
    await SharedPrefHelper.init();
    return {
      'email': SharedPrefHelper.getString('email') ?? '',
      'userType': SharedPrefHelper.getString('userType') ?? '',
      'token': SharedPrefHelper.getString('token') ?? '',
    };
  }

  void _login() async {
    String _email = _emailController.text.trim();
    String _password = _passwordController.text.trim();

    try {
      final response = await Dio().post(
        Constants.login,
        data: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.data['success'] == true) {
        final userData = response.data['user'];
        final token = response.data['access_token'];

        await saveUser(userData, token);

        final Map<String, dynamic> user = await getUser();
        final String usertoken = user['token'];

        show(context, response.data['message'], isError: false);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyHomePage()),
        // );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );

        // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

        print(usertoken);
      } else if (response.data['success'] == false) {
        print(response.data['message']);
        show(context, response.data['message'], isError: true);
      }
    } catch (error) {
      show(context, 'Error: ' + error.toString(), isError: true);
      print('Error: ' + error.toString());
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) {
        // Handle the case when the user object is null
        return;
      }

      if (!user.emailVerified) {
        show(context, "Email not verified. Please verify your email.",
            isError: true);

        // If the email is not verified, show an error message and prompt the user to verify their email
        throw FirebaseAuthException(
            code: 'user-not-verified',
            message: 'Please verify your email before logging in.');
      }

      _login();

      // The email is verified, allow the user to log in
      // You can navigate the user to the home screen or do any other action here
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        show(context, "User not found or Invalid email or password",
            isError: true);
        print('Invalid email or password');
      } else {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
