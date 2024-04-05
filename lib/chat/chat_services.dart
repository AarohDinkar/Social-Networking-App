import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialskills/model/message.dart';

class ChatService extends ChangeNotifier {
  // get instance of auth and firestore

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // send message
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        message: message,
        receiverId: receiverId,
        senderEmail: currentUserEmail,
        senderId: currentUserId,
        timestamp: timestamp);

    // construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId]; // sort the ids
    ids.sort();
    String chatRoomId = ids.join(
        "_"); // combine the ids into a single string to use as a chatroomId

    // add new message to database
    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userId, String otheruserId) {
    // construct chat room id from user ids (sorted to ensure it matches the id used when sending messages)
    List<String> ids = [userId, otheruserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
