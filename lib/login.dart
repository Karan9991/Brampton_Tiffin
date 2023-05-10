import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:tiffin/signup.dart';
import 'util/app_constants.dart';
import 'util/snackbar.dart';
import 'util/responsive_helper.dart';
import 'util/dimensions.dart';
import 'util/styles.dart';
import 'util/images.dart';
import 'package:get/get.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';
import 'guest_button.dart';
import 'util/shared_pref.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen();

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();

    // _countryDialCode =
    //     Get.find<AuthController>().getUserCountryCode().isNotEmpty
    //         ? Get.find<AuthController>().getUserCountryCode()
    //         : CountryCode.fromCountryCode(
    //                 Get.find<SplashController>().configModel.country)
    //             .dialCode;
    // _phoneController.text = Get.find<AuthController>().getUserNumber() ?? '';
    // _passwordController.text =
    //     Get.find<AuthController>().getUserPassword() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
          child: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Center(
              child: Container(
                width: context.width > 700 ? 700 : context.width,
                padding: context.width > 700
                    ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                    : null,
                decoration: context.width > 700
                    ? BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                      )
                    : null,
                child: Column(children: [
                  Image.asset(Images.tiffin, width: 100),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  Text('Brampton Tiffin'.tr,
                      style: robotoBlack.copyWith(fontSize: 20)),
                  SizedBox(height: 50),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                            spreadRadius: 1,
                            blurRadius: 5)
                      ],
                    ),
                    child: Column(children: [
                   
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_LARGE),
                          child: Divider(height: 1)),

                      CustomTextField(
                        hintText: 'Email'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Images.mail,
                        // onSubmit: (text) => (GetPlatform.isWeb && authController.acceptTerms)
                        //     ? _login(authController, _countryDialCode) : null,
                      ),
                      CustomTextField(
                        hintText: 'Password'.tr,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: Images.lock,
                        isPassword: true,
                        // onSubmit: (text) => (GetPlatform.isWeb && authController.acceptTerms)
                        //     ? _login(authController, _countryDialCode) : null,
                      ),
                    ]),
                  ),
                  SizedBox(height: 10),

                  Row(children: [
                    Expanded(
                      child: ListTile(
                        // onTap: () => authController.toggleRememberMe(),
                        leading: Checkbox(
                            activeColor: Theme.of(context).primaryColor,
                            value: _isChecked,
                            onChanged: (newValue) {
                              setState(() {
                                _isChecked = newValue!;
                              });
                              // onChanged: (bool isChecked) =>
                              //     authController.toggleRememberMe(),
                            }),
                        title: Text('Remember me'.tr),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        horizontalTitleGap: 0,
                      ),
                    ),
                    TextButton(
                      onPressed: () => {},
                      // onPressed: () => Get.toNamed(
                      //     RouteHelper.getForgotPassRoute(false, null)),
                      child: Text('${'Forgot Password'.tr}?'),
                    ),
                  ]),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                  // ConditionCheckBox(authController: authController),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  Row(children: [
                    Expanded(
                        child: CustomButton(
                            buttonText: 'Sign Up'.tr,
                            transparent: true,
                            onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()),
                                ) // Get.toNamed(RouteHelper.getSignUpRoute()),
                            )),
                    Expanded(
                        child: CustomButton(
                      buttonText: 'Sign In'.tr,
                      onPressed: _login,
                      // onPressed: authController.acceptTerms
                      //     ? () => _login(authController, _countryDialCode)
                      //     : null,
                    )),
                  ]),
                  SizedBox(height: 30),

                  // SocialLoginWidget(),

                  GuestButton(),
                ]),
              ),
            ),
          ),
        ),
      )),
    );
  }

  static Future<void> saveUser(
      Map<String, dynamic> userMap, String token) async {
    SharedPrefHelper.init();
    await SharedPrefHelper.setString('name', userMap['name']);
    await SharedPrefHelper.setString('email', userMap['email']);
    await SharedPrefHelper.setString('address', userMap['address']);
    await SharedPrefHelper.setString('userType', userMap['user_type']);
    await SharedPrefHelper.setString('token', token);
  }

  static Future<Map<String, dynamic>> getUser() async {
    SharedPrefHelper.init();
    return {
      'name': SharedPrefHelper.getString('name') ?? '',
      'email': SharedPrefHelper.getString('email') ?? '',
      'address': SharedPrefHelper.getString('address') ?? '',
      'userType': SharedPrefHelper.getString('userType') ?? '',
      'token': SharedPrefHelper.getString('token') ?? '',
    };
  }

  void _login() async {
    String _email = _emailController.text.trim();
    String _password = _passwordController.text.trim();

    if (_email.isEmpty) {
      show(context, 'Enter Email'.tr);
    } else if (!GetUtils.isEmail(_email)) {
      show(context, 'Enter a valid Email address'.tr);
    } else if (_password.isEmpty) {
      show(context, 'Enter Password'.tr);
    } else {
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
  }
}
