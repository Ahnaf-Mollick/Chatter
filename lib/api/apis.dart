import 'package:chatter/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;
  static late ChatUser me;
  //for checking existed user
  static Future<void> getSelfInfo() async {
    await firestore.collection('user').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<bool> userExists() async {
    return (await firestore.collection('user').doc(user.uid).get()).exists;
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        about: 'Hey!I am using Chatter',
        name: user.displayName.toString(),
        createdAt: time,
        id: user.uid,
        lastActive: time,
        isOnline: false,
        email: user.email.toString(),
        pushToken: '');

    return (await firestore
        .collection('user')
        .doc(user.uid)
        .set(chatUser.toJson()));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('user')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore
        .collection('user')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }
}
