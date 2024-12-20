import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample_chat_app/models/chat_model.dart';
import 'package:sample_chat_app/models/message_model.dart';
import 'package:sample_chat_app/models/user_profile_model.dart';
import 'package:sample_chat_app/services/auth_services.dart';
import 'package:sample_chat_app/services/database_service.dart';
import 'package:sample_chat_app/services/media_service.dart';
import 'package:sample_chat_app/services/storage_service.dart';
import 'package:sample_chat_app/utils.dart';
import 'package:sample_chat_app/widgets/upload_files_bottom_sheet.dart';

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
                  leading: [uploadMediaButton()],
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

  //Funtions related to uploading image, video, sending and fetching chat messages --->

  List<ChatMessage> generateChatMessageList(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map(
      (m) {
        debugPrint('Message type fetched is  ${m.content}:${m.messageType}');
        if (m.messageType == MessageType.Image) {
          return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            medias: [
              ChatMedia(url: m.content!, fileName: '', type: MediaType.image)
            ],
            createdAt: m.sentAt!.toDate(),
          );
        } else if (m.messageType == MessageType.Video) {
          return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            medias: [
              ChatMedia(url: m.content!, fileName: '', type: MediaType.video)
            ],
            createdAt: m.sentAt!.toDate(),
          );
        } else if (m.messageType == MessageType.File) {
          return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            medias: [
              ChatMedia(
                  url: m.content!, fileName: m.content!, type: MediaType.file)
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
        debugPrint('Entered in the image send block');
        Message message = Message(
          senderID: currentUser!.id,
          content: chatMessage.medias!.first.url,
          messageType: MessageType.Image,
          sentAt: Timestamp.fromDate(chatMessage.createdAt),
        );

        await DatabaseService.instance
            .sendChatMessage(currentUser!.id, otherUser!.id, message);
      } else if (chatMessage.medias!.first.type == MediaType.video) {
        debugPrint('Entered in the video send block');
        Message message = Message(
          senderID: currentUser!.id,
          content: chatMessage.medias!.first.url,
          messageType: MessageType.Video,
          sentAt: Timestamp.fromDate(chatMessage.createdAt),
        );

        await DatabaseService.instance
            .sendChatMessage(currentUser!.id, otherUser!.id, message);
      } else if (chatMessage.medias!.first.type == MediaType.file) {
        debugPrint('Entered in the file send block');
        Message message = Message(
          senderID: currentUser!.id,
          content: chatMessage.medias!.first.url,
          messageType: MessageType.File,
          sentAt: Timestamp.fromDate(chatMessage.createdAt),
        );

        await DatabaseService.instance
            .sendChatMessage(currentUser!.id, otherUser!.id, message);
      }
    } else {
      debugPrint('Entered in the text send block');
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

  Future<void> imageUploadProcess() async {
    File? file = await MediaService.instance.getImageFromGallery();
    Get.back();
    Get.snackbar('Uploading', 'Image uploading in process...');
    if (file != null) {
      String chatId =
          Utils.generateChatId(uid1: currentUser!.id, uid2: otherUser!.id);
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
  }

  Future<void> videoUploadProcess() async {
    File? file = await MediaService.instance.getVideoFromGallery();
    Get.back();
    Get.snackbar('Uploading', 'Video uploading in process...');
    if (file != null) {
      String chatId =
          Utils.generateChatId(uid1: currentUser!.id, uid2: otherUser!.id);
      String? downloadUrl = await StorageService.instance
          .uploadVideoToChat(chatId: chatId, file: file);
      if (downloadUrl != null) {
        ChatMessage chatMessage = ChatMessage(
          user: currentUser!,
          medias: [
            ChatMedia(url: downloadUrl, fileName: '', type: MediaType.video)
          ],
          createdAt: DateTime.now(),
        );
        sendMessage(chatMessage);
      }
    }
  }

  Future<void> pdfUploadProcess() async {
    File? file = await MediaService.instance.getPdfFile();
    Get.back();
    Get.snackbar('Uploading', 'Pdf uploading in process...');
    if (file != null) {
      String chatId =
          Utils.generateChatId(uid1: currentUser!.id, uid2: otherUser!.id);
      String? downloadUrl = await StorageService.instance
          .uploadPdfToChat(chatId: chatId, file: file);
      if (downloadUrl != null) {
        debugPrint('Download URL is $downloadUrl');
        ChatMessage chatMessage = ChatMessage(
          user: currentUser!,
          medias: [
            ChatMedia(
                url: downloadUrl, fileName: downloadUrl, type: MediaType.file)
          ],
          createdAt: DateTime.now(),
        );
        sendMessage(chatMessage);
      }
    }
  }

  Widget uploadMediaButton() {
    return IconButton(
      icon: const Icon(Icons.attach_file),
      onPressed: () {
        Get.bottomSheet(
          UploadFilesBottomSheet(
              onPdfClick: pdfUploadProcess,
              onGalleryClick: imageUploadProcess,
              onCameraClick: videoUploadProcess),
        );
      },
    );
  }
}
