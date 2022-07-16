import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

enum MessageStatus {
  sending,
  delivered,
  read,
  error,
}

enum MessageType {
  text,
  image,
  audio,
  date,
}

class Message {
  final String id;
  final String authorId;
  final String textContent;
  final List<String> mediaFiles;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final MessageStatus status;
  final MessageType type;

  const Message(
      {required this.id,
      required this.authorId,
      required this.textContent,
      this.status = MessageStatus.sending,
      this.type = MessageType.text,
      this.mediaFiles = const [],
      this.createdAt,
      this.modifiedAt});

  Message.fromText(this.authorId, {required this.textContent})
      : id = '',
        type = MessageType.text,
        mediaFiles = [],
        status = MessageStatus.sending,
        createdAt = null,
        modifiedAt = null;

  Message.fromImages(this.authorId, {required this.mediaFiles, this.textContent = ''})
      : id = '',
        type = MessageType.image,
        status = MessageStatus.sending,
        createdAt = null,
        modifiedAt = null;

  Message.fromDate(DateTime date, {String format = 'E, dd / MM'})
      : id = '',
        authorId = '',
        textContent = date.day == DateTime.now().day ? 'Today' : DateFormat(format).format(date),
        type = MessageType.date,
        mediaFiles = [],
        status = MessageStatus.sending,
        createdAt = null,
        modifiedAt = null;

  static Message fromJSON(Map<String, dynamic> json) {
    final createdAt = json['createdAt'];
    final modifiedAt = json['modifiedAt'];

        // Timestamp is a type from firestore for storing Date time related data
    return Message(
      id: json['id'] ?? '',
      type: MessageType.values.asNameMap()[json['type']] ?? MessageType.text,
      authorId: json['authorId'] ?? '',
      textContent: json['textContent'] ?? '',
      mediaFiles: json['mediaFiles'] is List ? (json['mediaFiles'] as List).cast<String>() : [],
      status: createdAt != null ? MessageStatus.delivered : MessageStatus.sending,
      createdAt: createdAt is Timestamp ? createdAt.toDate() : null,
      modifiedAt: modifiedAt is Timestamp ? modifiedAt.toDate() : null);
  }

    // This is used to deserialize the data for firestore
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> json = {
      'authorId': authorId,
      'type': type.toString().split('.').last,
      'textContent': textContent,
      'createdAt': FieldValue.serverTimestamp(),
      'modifiedAt': FieldValue.serverTimestamp(),
    };

    if (mediaFiles.isNotEmpty) {
      json['mediaFiles'] = mediaFiles;
    }

    return json;
  }
}