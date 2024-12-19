import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:sample_chat_app/models/chat_model.dart';
import 'package:sample_chat_app/models/message_model.dart';
import 'package:sample_chat_app/models/user_profile_model.dart';
import 'package:sample_chat_app/services/auth_services.dart';
import 'package:sample_chat_app/services/database_service.dart';
import 'package:sample_chat_app/services/media_service.dart';
import 'package:sample_chat_app/services/storage_service.dart';
import 'package:sample_chat_app/utils.dart';

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
      body: SafeArea(
        child: StreamBuilder(
          stream: DatabaseService.instance
              .getChatData(currentUser!.id, otherUser!.id),
          builder: (context, snapshot) {
            Chat? chat = snapshot.data?.data();
            List<ChatMessage> message = [];
            if (chat != null && chat.messages != null) {
              message = generateChatMessageList(chat.messages!);
            }
            return DashChat(
                messageOptions: const MessageOptions(
                    showOtherUsersAvatar: true, showTime: true),
                currentUser: currentUser!,
                inputOptions: InputOptions(
                  alwaysShowSend: true,
                  leading: [
                    mediaMessageButton(),
                  ],
                ),
                onSend: (message) {
                  debugPrint('Send messsage clicked');
                  sendMessage(message);
                },
                messages: message);
          },
        ),
      ),
    );
  }

  List<ChatMessage> generateChatMessageList(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map(
      (m) {
        if (m.messageType == MessageType.Image) {
          return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            medias: [
              ChatMedia(url: m.content!, fileName: '', type: MediaType.image)
            ],
            createdAt: m.sentAt!.toDate(),
          );
        } else {
          return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            text: m.content!,
            createdAt: m.sentAt!.toDate(),
          );
        }
      },
    ).toList();
    chatMessages.sort(
      (a, b) {
        return b.createdAt.compareTo(a.createdAt);
      },
    );
    return chatMessages;
  }

  Future<void> sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      if (chatMessage.medias!.first.type == MediaType.image) {
        Message message = Message(
          senderID: currentUser!.id,
          content: chatMessage.medias!.first.url,
          messageType: MessageType.Image,
          sentAt: Timestamp.fromDate(chatMessage.createdAt),
        );

        await DatabaseService.instance
            .sendChatMessage(currentUser!.id, otherUser!.id, message);
      }
    } else {
      Message message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt),
      );

      await DatabaseService.instance
          .sendChatMessage(currentUser!.id, otherUser!.id, message);
    }
  }

  Widget mediaMessageButton() {
    return IconButton(
      onPressed: () async {
        File? file = await MediaService.instance.getImageFromGallery();
        if (file != null) {
          String chatId =
              generateChatId(uid1: currentUser!.id, uid2: otherUser!.id);
          String? downloadUrl = await StorageService.instance
              .uploadImageToChat(chatId: chatId, file: file);
          if (downloadUrl != null) {
            ChatMessage chatMessage = ChatMessage(
              user: currentUser!,
              medias: [
                ChatMedia(url: downloadUrl, fileName: '', type: MediaType.image)
              ],
              createdAt: DateTime.now(),
            );
            sendMessage(chatMessage);
          }
        }
      },
      icon: const Icon(Icons.attach_file_rounded),
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
