import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  ChatRepository(this._db);
  final FirebaseFirestore _db;

  Stream<QuerySnapshot<Map<String, dynamic>>> watchMessages(String chatId) {
    return _db.collection('chats').doc(chatId).collection('messages').orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> sendMessage({required String chatId, required String senderId, required String text}) {
    return _db.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
