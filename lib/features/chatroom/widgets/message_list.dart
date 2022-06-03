import 'package:flutter/material.dart';
import 'package:tecky_chat/features/chatroom/widgets/date_message.dart';
import 'package:tecky_chat/features/chatroom/widgets/message_bubble.dart';
import 'package:tecky_chat/features/chatroom/widgets/text_message.dart';
import 'package:tecky_chat/theme/colors.dart';

class MessageList extends StatelessWidget {
  final List<String> messages;

  const MessageList({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: messages
            .asMap()
            .map((index, message) {
              if (message == '---') {
                const widget = Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: DateMessage(title: 'Sat, 17/11'));

                return MapEntry(index, widget);
              }

              final isIncoming = index % 2 == 0;
              final widget = Container(
                  alignment: isIncoming ? Alignment.centerLeft : Alignment.centerRight,
                  child: MessageBubble(
                    direction: isIncoming
                        ? MessageBubbleDirection.incoming
                        : MessageBubbleDirection.outgoing,
                    child: TextMessage(
                      textContent: message,
                      textColor: isIncoming ? ThemeColors.neutralActive : ThemeColors.neutralWhite,
                    ),
                  ));

              return MapEntry(index, widget);
            })
            .values
            .toList());
  }
}
