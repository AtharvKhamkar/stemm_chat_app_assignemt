import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample_chat_app/consts.dart';
import 'package:sample_chat_app/services/auth_services.dart';
import 'package:sample_chat_app/services/media_service.dart';
import 'package:sample_chat_app/widgets/custom_form_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> registrationFormKey = GlobalKey();
  String? email, password;
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileSelection(),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Form(
                  key: registrationFormKey,
                  child: Column(
                    children: [
                      CustomFormField(
                        hintText: 'Email',
                        height: Get.height * 0.1,
                        validationRegEx: EMAIL_VALIDATION_REGEX,
                        onSave: (value) {
                          setState(
                            () {
                              email = value;
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      CustomFormField(
                        hintText: 'Password',
                        height: Get.height * 0.1,
                        validationRegEx: PASSWORD_VALIDATION_REGEX,
                        onSave: (value) {
                          setState(
                            () {
                              password = value;
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (registrationFormKey.currentState?.validate() ??
                              false) {
                            registrationFormKey.currentState?.save();
                            debugPrint(email);
                            debugPrint(password);
                            bool result = await AuthService.instance
                                .registerUser(email!, password!);
                            debugPrint(
                                'Result of the registration process $result');
                            if (result) {
                              Get.snackbar(
                                  'Registration', 'Registration Successfull!');
                              Get.offAllNamed('/home');
                            } else {
                              Get.snackbar(
                                  'Registration', 'Registration Failed!');
                            }
                          }
                        },
                        child: Container(
                          height: Get.height * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ProfileSelection() {
    return GestureDetector(
      onTap: () async {
        File? file = await MediaService.instance.getImageFromGallery();
        setState(() {
          selectedImage = file;
        });
      },
      child: CircleAvatar(
        radius: Get.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }
}
