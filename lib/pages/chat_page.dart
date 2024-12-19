import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:sample_chat_app/models/user_profile_model.dart';
import 'package:sample_chat_app/services/auth_services.dart';

class ChatPage extends StatefulWidget {
  final UserProfile chatUser;
  const ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUser? currentUser, otherUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = ChatUser(
        id: AuthService.instance.user!.uid,
        firstName: AuthService.instance.user!.displayName);

    otherUser = ChatUser(
        id: widget.chatUser.uid!,
        firstName: widget.chatUser.name,
        profileImage: widget.chatUser.pfpURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser.name!),
      ),
    );
  }
}
