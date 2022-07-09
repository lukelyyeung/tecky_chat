import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';

class Chatroom {
  final String id;
  final String displayName;
  final String? iconUrl;
  final bool isGroup;
  final List<String> participants;
  final Message? latestMessage;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final DateTime? latestMessageAt;

  const Chatroom({
    required this.id,
    required this.displayName,
    this.iconUrl,
    this.isGroup = false,
    this.participants = const [],
    this.latestMessage,
    this.createdAt,
    this.modifiedAt,
    this.latestMessageAt,
  });

  static const empty = Chatroom(id: '', displayName: '');

  static Map<String, dynamic> createChatroomPayload(
      {required String userId, required String opponentId}) {
    return {
      "isGroup": false,
      "participant": {userId: true, opponentId: true},
      "participants": [opponentId, userId],
      "createdAt": FieldValue.serverTimestamp(),
      "modifiedAt": FieldValue.serverTimestamp(),
      "latestMessageAt": FieldValue.serverTimestamp(),
    };
  }

  Chatroom.fromJSON(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        displayName = json['displayName'] ?? '',
        iconUrl = json['iconUrl'],
        isGroup = json['isGroup'] ?? false,
        participants = (json['participants'] as List<dynamic>? ?? const []).cast<String>(),
        latestMessage = null,
        createdAt = json['createdAt'] is Timestamp
            ? (json['createdAt'] as Timestamp).toDate()
            : DateTime.now(),
        modifiedAt = json['modifiedAt'] is Timestamp
            ? (json['modifiedAt'] as Timestamp).toDate()
            : DateTime.now(),
        latestMessageAt = json['latestMessageAt'] is Timestamp
            ? (json['latestMessageAt'] as Timestamp).toDate()
            : DateTime.now();

  copyWith({
    String? displayName,
    String? iconUrl,
    bool? isGroup,
    List<String>? participants,
    Message? latestMessage,
    DateTime? createdAt,
    DateTime? modifiedAt,
    DateTime? latestMessageAt,
  }) {
    return Chatroom(
      id: id,
      displayName: displayName ?? this.displayName,
      iconUrl: iconUrl ?? this.iconUrl,
      isGroup: isGroup ?? this.isGroup,
      participants: participants ?? this.participants,
      latestMessage: latestMessage ?? this.latestMessage,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      latestMessageAt: latestMessageAt ?? this.latestMessageAt,
    );
  }
}
