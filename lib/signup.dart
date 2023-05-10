import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:tiffin/login.dart';
import 'package:tiffin/util/app_constants.dart';
import 'util/snackbar.dart';
import 'util/images.dart';
import 'dart:convert';
import 'util/dimensions.dart';
import 'util/responsive_helper.dart';
import 'custom_text_field.dart';
import 'util/styles.dart';
import 'package:get/get.dart';
import 'custom_button.dart';
import 'guest_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late String _selectedUserType = 'Select User Type';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
          child: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          physics: BouncingScrollPhysics(),
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
                // Image.asset(Images.logo_name, width: 100),
                // SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                Text('Brampton Tiffin'.tr,
                    style: robotoBlack.copyWith(fontSize: 20)),
                SizedBox(height: 15),

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
                    CustomTextField(
                      hintText: 'Name'.tr,
                      controller: _nameController,
                      focusNode: _nameFocus,
                      nextFocus: _phoneFocus,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                      prefixIcon: Images.user,
                      divider: true,
                    ),
                    CustomTextField(
                      hintText: 'Phone'.tr,
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      nextFocus: _addressFocus,
                      inputType: TextInputType.phone,
                      prefixIcon: Images.call,
                      divider: true,
                    ),
                    CustomTextField(
                      hintText: 'Address'.tr,
                      controller: _addressController,
                      focusNode: _addressFocus,
                      nextFocus: _emailFocus,
                      inputType: TextInputType.streetAddress,
                      prefixIcon: Images.user_marker,
                      divider: true,
                    ),
                    CustomTextField(
                      hintText: 'Email'.tr,
                      controller: _emailController,
                      focusNode: _emailFocus,
                      nextFocus: _passwordFocus,
                      inputType: TextInputType.emailAddress,
                      prefixIcon: Images.mail,
                      divider: true,
                    ),

                    // Row(children: [
                    //   CodePickerWidget(
                    //     onChanged: (CountryCode countryCode) {
                    //       _countryDialCode = countryCode.dialCode;
                    //     },
                    //     initialSelection: CountryCode.fromCountryCode(
                    //             Get.find<SplashController>()
                    //                 .configModel
                    //                 .country)
                    //         .code,
                    //     favorite: [
                    //       CountryCode.fromCountryCode(
                    //               Get.find<SplashController>()
                    //                   .configModel
                    //                   .country)
                    //           .code
                    //     ],
                    //     showDropDownButton: true,
                    //     padding: EdgeInsets.zero,
                    //     showFlagMain: true,
                    //     dialogBackgroundColor: Theme.of(context).cardColor,
                    //     textStyle: robotoRegular.copyWith(
                    //       fontSize: Dimensions.fontSizeLarge,
                    //       color: Theme.of(context).textTheme.bodyLarge.color,
                    //     ),
                    //   ),
                    //   Expanded(
                    //       child: CustomTextField(
                    //     hintText: 'phone'.tr,
                    //     controller: _phoneController,
                    //     focusNode: _phoneFocus,
                    //     nextFocus: _passwordFocus,
                    //     inputType: TextInputType.phone,
                    //     divider: false,
                    //   )),
                    // ]),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_LARGE),
                        child: Divider(height: 1)),
                    CustomTextField(
                      hintText: 'password'.tr,
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      nextFocus: _confirmPasswordFocus,
                      inputType: TextInputType.visiblePassword,
                      prefixIcon: Images.lock,
                      isPassword: true,
                      divider: true,
                    ),
                    CustomTextField(
                      hintText: 'confirm_password'.tr,
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      // nextFocus: Get.find<SplashController>()
                      //             .configModel
                      //             .refEarningStatus ==
                      //         1
                      //     ? _referCodeFocus
                      //     : null,
                      // inputAction: Get.find<SplashController>()
                      //             .configModel
                      //             .refEarningStatus ==
                      //         1
                      //     ? TextInputAction.next
                      //     : TextInputAction.done,
                      inputType: TextInputType.visiblePassword,
                      prefixIcon: Images.lock,
                      isPassword: true,
                      divider: true,

                      // divider: Get.find<SplashController>()
                      //             .configModel
                      //             .refEarningStatus ==
                      //         1
                      //     ? true
                      //     : false,
                      // onSubmit: (text) =>
                      //     (GetPlatform.isWeb && authController.acceptTerms)
                      //         ? _register(authController, _countryDialCode)
                      //         : null,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'User Type',
                      ),
                      value: _selectedUserType,
                      onChanged: (value) {
                        setState(() {
                          _selectedUserType = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value == 'Select User Type') {
                          return 'Please select a user type';
                        }
                        return null;
                      },
                      items: <String>['Select User Type', 'Customer', 'Seller']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // (Get.find<SplashController>()
                    //             .configModel
                    //             .refEarningStatus ==
                    //         1)
                    //     ? CustomTextField(
                    //         hintText: 'refer_code'.tr,
                    //         controller: _referCodeController,
                    //         focusNode: _referCodeFocus,
                    //         inputAction: TextInputAction.done,
                    //         inputType: TextInputType.text,
                    //         capitalization: TextCapitalization.words,
                    //         prefixIcon: Images.refer_code,
                    //         divider: false,
                    //         prefixSize: 14,
                    //       )
                    //     : SizedBox(),
                  ]),
                ),

                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                // ConditionCheckBox(authController: authController),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Row(children: [
                  Expanded(
                      child: CustomButton(
                          buttonText: 'Sign In'.tr,
                          transparent: true,
                          onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen()),
                              )

                          // onPressed: () => {},
                          )),
                  Expanded(
                      child: CustomButton(
                    buttonText: 'Sign Up'.tr,
                    onPressed: _register,
                    // onPressed: authController.acceptTerms
                    //     ? () =>
                    //         _register(authController, _countryDialCode)
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
      )),
    );
  }

  void _register() async {
    print("click signup");
    String _name = _nameController.text.trim();
    String _address = _addressController.text.trim();
    String _email = _emailController.text.trim();
    String _phone = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    if (_name.isEmpty) {
      show(context, 'Enter your Name'.tr);
    } else if (_address.isEmpty) {
      show(context, 'Enter your Address'.tr);
    } else if (_email.isEmpty) {
      show(context, 'Enter your Email'.tr);
    } else if (!GetUtils.isEmail(_email)) {
      show(context, 'Enter a valid Email address'.tr);
    } else if (_password.isEmpty) {
      show(context, 'Enter Password'.tr);
    } else if (_password.length < 6) {
      show(context, 'password_should_be'.tr);
    } else if (_selectedUserType == 'Select User Type') {
      show(context, 'Please select user type'.tr);
    } else if (_password != _confirmPassword) {
      show(context, 'confirm_password_does_not_matched'.tr);
    } else {
      try {
        final response = await Dio().post(
          Constants.register,
          data: {
            'name': _nameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'address': _addressController.text,
            'user_type': _selectedUserType,
          },
        );

        if (response.statusCode == 201) {
          final responseData = response.data;
          // Show success message to the user
          show(context, response.data['message'], isError: false);
        } else {
          // Show error message to the user
          show(context, 'Error: ${response.statusMessage}');
          print('else ${response.statusMessage}');
        }
      } catch (error) {
        show(context, 'Error: $error');
        print('catch $error');
      }
    }
  }
}
