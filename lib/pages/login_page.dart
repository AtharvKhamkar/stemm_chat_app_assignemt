import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample_chat_app/consts.dart';
import 'package:sample_chat_app/services/auth_services.dart';
import 'package:sample_chat_app/widgets/custom_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email, password;
  final GlobalKey<FormState> loginFormKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: Get.width,
                  child: const Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi Welcome Back!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Hello again, you have been missed',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.1,
                ),
                Form(
                  key: loginFormKey,
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
                        isSuffixIcon: true,
                        obsecureText: true,
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
                          if (loginFormKey.currentState?.validate() ?? false) {
                            loginFormKey.currentState?.save();
                            debugPrint(email);
                            debugPrint(password);
                            bool result = await AuthService.instance
                                .loginUser(email!, password!);
                            if (result) {
                              // ScaffoldMessenger.of(context)
                              //     .showSnackBar(const SnackBar(
                              //   content: Text('Login Successfull!'),
                              // ));
                              Get.snackbar('Login', 'Login successfull!');
                              Get.offAllNamed('/home');
                            } else {
                              Get.snackbar('Login', 'Login Failed!');
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
                              'Login',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // const Spacer(),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/registration');
                  },
                  child: const Text('Dont have an account? Please register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
