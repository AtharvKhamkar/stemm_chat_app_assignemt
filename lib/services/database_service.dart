import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_chat_app/models/chat_model.dart';
import 'package:sample_chat_app/models/message_model.dart';
import 'package:sample_chat_app/models/user_profile_model.dart';
import 'package:sample_chat_app/services/auth_services.dart';
import 'package:sample_chat_app/utils.dart';

class DatabaseService {
  DatabaseService._() {
    setupCollectionReference();
  }

  static final DatabaseService _instance = DatabaseService._();

  static DatabaseService get instance => _instance;

  final FirebaseFirestore firebaseStorage = FirebaseFirestore.instance;

  CollectionReference? userCollection;
  CollectionReference? chatCollection;

  void setupCollectionReference() {
    userCollection =
        firebaseStorage.collection('users').withConverter<UserProfile>(
              fromFirestore: (snapshot, _) =>
                  UserProfile.fromJson(snapshot.data()!),
              toFirestore: (userProfile, _) => userProfile.toJson(),
            );
    chatCollection = firebaseStorage.collection('chats').withConverter<Chat>(
        fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
        toFirestore: (chat, _) => chat.toJson());
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await userCollection?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfile() {
    return userCollection
        ?.where('uid', isNotEqualTo: AuthService.instance.user?.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Stream<DocumentSnapshot<Chat>> getChatData(String uid1, String uid2) {
    final chatId = Utils.generateChatId(uid1: uid1, uid2: uid2);
    return chatCollection!.doc(chatId).snapshots()
        as Stream<DocumentSnapshot<Chat>>;
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    final chatId = Utils.generateChatId(uid1: uid1, uid2: uid2);
    final result = await chatCollection?.doc(chatId).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatId = Utils.generateChatId(uid1: uid1, uid2: uid2);
    final ref = chatCollection!.doc(chatId);
    final chat = Chat(id: chatId, participants: [uid1, uid2], messages: []);
    await ref.set(chat);
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message) async {
    String chatId = Utils.generateChatId(uid1: uid1, uid2: uid2);
    final docRef = chatCollection!.doc(chatId);
    await docRef.update(
      {
        'messages': FieldValue.arrayUnion(
          [
            message.toJson(),
          ],
        )
      },
    );
  }
}
