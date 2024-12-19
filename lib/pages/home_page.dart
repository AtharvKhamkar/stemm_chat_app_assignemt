import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample_chat_app/models/user_profile_model.dart';
import 'package:sample_chat_app/services/auth_services.dart';
import 'package:sample_chat_app/services/database_service.dart';
import 'package:sample_chat_app/widgets/chat_tile.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: DatabaseService.instance.getUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Unable to load data'),
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
                final users = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    UserProfile userProfile = users[index].data();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ChatTile(userProfile: userProfile, onTap: () {}),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.grey,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
