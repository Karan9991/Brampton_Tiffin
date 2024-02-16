import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiffin/util/app_constants.dart';
import 'package:tiffin/util/shared_pref.dart';
import 'package:tiffin/util/snackbar.dart';

class CreateTiffinPage extends StatefulWidget {
  const CreateTiffinPage({Key? key}) : super(key: key);

  @override
  _CreateTiffinPageState createState() => _CreateTiffinPageState();
}

class _CreateTiffinPageState extends State<CreateTiffinPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  final _nameFocus = FocusNode();
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  int _currentUserId = 0;

  late File? _image = null;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserId();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  focusNode: _nameFocus,
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Tiffin Name',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter tiffin name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16.0, // adjust the height to your desired padding
                ),
                TextFormField(
                  focusNode: _priceFocus,
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3)
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Price',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter tiffin price';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16.0, // adjust the height to your desired padding
                ),
                TextFormField(
                  focusNode: _descriptionFocus,
                  controller: _descriptionController,
                  maxLines: 15,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(fontSize: 15.0),
                    hintText:
                        'Description:\n \nDelicious homemade vegetarian tiffin made with fresh ingredients and spices.\nCustomizable tiffin with options for vegan, gluten-free...\n\nContact:\n \nEmail: example@gmail.com\nPhone: +1-555-1234-567\nWhatsApp: +1-555-1234-567 (preferred)\nInstagram: @example_tiffin\nFacebook: Example Tiffin Services',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter tiffin description';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16.0, // adjust the height to your desired padding
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: _image == null
                      ? Text('No image selected.')
                      : SizedBox(
                          height: 130,
                          width: 130,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: getImage,
                      child: Text(
                        "Select Tiffin Image",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Send data to server using Dio
                        _createTiffin();
                      }
                    },
                    child: Text(
                      'Publish Tiffin',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createTiffin() async {
    final name = _nameController.text;
    final price = _priceController.text;
    final description = _descriptionController.text;

    if (_image == null) {
      // Show an error message if no image is selected
      return;
    }

    final formData = FormData.fromMap({
      'name': name,
      'price': price,
      'description': description,
      'image': await MultipartFile.fromFile(_image!.path),
      'user_id': _currentUserId,
    });

    print('name $name');
        print('price $price');
    print('description $description');
    print('user_id $_currentUserId');
    print('image {$MultipartFile.fromFile(_image!.path)}');


    final dio = Dio();
    try {
      final response = await dio.post(
        Constants.posttiffin,
        data: formData,
        options: Options(
          followRedirects: true,
          // other options...
        ),
      );
      if (response.statusCode == 200) {
        // Handle success response
        show(context, response.data['message'], isError: false);
        setState(() {
          _nameController.text = '';
          _priceController.text = '';
          _descriptionController.text = '';
          _image = null;
          _nameFocus.unfocus;
          _priceFocus.unfocus;
          _descriptionFocus.unfocus;
        });

        print('Tiffin created successfully!');
      } else {
        // Handle other status codes
      }
    } catch (e) {
      // Handle error
      print('Error creating tiffin: $e');
    }
  }

  Future<void> _getUserId() async {
    final Map<String, dynamic> user = await getUser();
    setState(() {
      _currentUserId = user['id'];
    });
  }

  static Future<Map<String, dynamic>> getUser() async {
    await SharedPrefHelper.init();
    return {
      'id': SharedPrefHelper.getInt('id') ?? 0,
      'email': SharedPrefHelper.getString('email') ?? '',
      'userType': SharedPrefHelper.getString('userType') ?? '',
      'token': SharedPrefHelper.getString('token') ?? '',
    };
  }
}
