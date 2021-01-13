import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DBmethods {
  getUsers(String userName) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: userName)
        .get();
  }

  getUserwithEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  uploadUserInfo(userMap, uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  createChat(String roomId, chatMap) async {
    return await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .set(chatMap)
        .catchError((e) => {print(e)});
  }

  addMessage(String roomId, messageMap) async {
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .add(messageMap)
        .catchError(
          (e) => {
            print(e.code.toString()),
          },
        );
  }

  getMessages(String roomId) async {
    return await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  getRooms(String email) async {
    return await FirebaseFirestore.instance
        .collection('rooms')
        .where('userMails', arrayContains: email)
        // .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
