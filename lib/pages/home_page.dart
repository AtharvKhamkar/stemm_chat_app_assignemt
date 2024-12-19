import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample_chat_app/services/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await AuthService.instance.logoutUser();
                Get.snackbar('Logout', 'Logged out successfully!');
                Get.offAllNamed('/login');
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
    );
  }
}
