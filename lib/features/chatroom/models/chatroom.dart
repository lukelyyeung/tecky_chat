import 'package:tecky_chat/features/chatroom/models/message.dart';

class Chatroom {
  final String id;
  final String displayName;
  final String? iconUrl;
  final bool isGroup;
  final List<String> participants;
  final Message? latestMessage;

  Chatroom({
    required this.id,
    required this.displayName,
    this.iconUrl,
    this.isGroup = false,
    this.participants = const [],
    this.latestMessage,
  });
}
