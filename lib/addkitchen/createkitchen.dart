import 'dart:io';
import 'package:tiffin/util/snackbar.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiffin/util/app_constants.dart';
import 'package:tiffin/util/shared_pref.dart';

class CreateKitchenPage extends StatefulWidget {
  const CreateKitchenPage({Key? key}) : super(key: key);

  @override
  _CreateKitchenPageState createState() => _CreateKitchenPageState();
}

class _CreateKitchenPageState extends State<CreateKitchenPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late File? _imageFile = null;
  int _currentUserId = 0;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _createKitchen() async {
    final kitchenData = await fetchKitchenData(_currentUserId);
    if (kitchenData.isEmpty) {
      // Allow user to create kitchen
      // ...
      if (_imageFile == null || _nameController.text.isEmpty) {
        return;
      }
      final String fileName = _imageFile!.path.split('/').last;
      final FormData formData = FormData.fromMap({
        'image':
            await MultipartFile.fromFile(_imageFile!.path, filename: fileName),
        'name': _nameController.text,
        'user_id': _currentUserId,
      });
      final Response response = await Dio().post(
        Constants.kitchens,
        data: formData,
      );
      if (response.statusCode == 200) {
        // Do something on success
        show(context, response.data['message'], isError: false);
        print(response.data);
        _nameController.text = '';
        _nameFocus.unfocus();
        setState(() {
          _imageFile = null; // clear image
        });
      } else {
        // Handle error

        print(response.statusMessage);
      }
    } else {
      show(context, 'You can not create two kitchens', isError: true);

      // Show error message that user already has a kitchen
      // ...
    }
  }

  Future<List<dynamic>> fetchKitchenData(int userId) async {
    final String url = Constants.getkitchen;
    final Map<String, dynamic> queryParameters = {'user_id': userId};

    final Response response = await Dio().get(
      url,
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      final dynamic data = response.data;
      if (data != null && data.containsKey('data')) {
        return data['data'];
      } else {
        // Return an empty list if the response does not contain any kitchens
        return [];
      }
    } else {
      throw Exception('Failed to fetch kitchen data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: _getImageFromGallery,
                icon: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                label: Text(
                  'Upload Kitchen Banner',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              if (_imageFile != null)
                SizedBox(
                  height: 200,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  labelText: 'Kitchen Name',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Kitchen Name';
                  }
                  return null;
                },
              ),
              // TextField(
              //   controller: _nameController,
              //   focusNode: _nameFocus,
              //   decoration: InputDecoration(
              //     labelText: 'Kitchen Name',
              //     border: OutlineInputBorder(),

              //   ),
              // ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  if (_imageFile == null) {
                    show(context, "Please Upload Kitchen Banner",
                        isError: true);
                    return;
                  }

                  _createKitchen();
                },
                child: Text(
                  'Create Kitchen',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
