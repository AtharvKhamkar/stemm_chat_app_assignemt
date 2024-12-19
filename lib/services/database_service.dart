import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_chat_app/models/user_profile_model.dart';

class DatabaseService {
  DatabaseService._() {
    setupCollectionReference();
  }

  static final DatabaseService _instance = DatabaseService._();

  static DatabaseService get instance => _instance;

  final FirebaseFirestore firebaseStorage = FirebaseFirestore.instance;

  CollectionReference? userCollection;

  void setupCollectionReference() {
    userCollection =
        firebaseStorage.collection('users').withConverter<UserProfile>(
              fromFirestore: (snapshot, _) =>
                  UserProfile.fromJson(snapshot.data()!),
              toFirestore: (userProfile, _) => userProfile.toJson(),
            );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await userCollection?.doc(userProfile.uid).set(userProfile);
  }
}
