import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tecky_chat/features/auth/blocs/auth_bloc.dart';
import 'package:tecky_chat/features/auth/blocs/auth_state.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';
import 'package:tecky_chat/features/chatroom/widgets/date_message.dart';
import 'package:tecky_chat/features/chatroom/widgets/message_bubble.dart';
import 'package:tecky_chat/features/chatroom/widgets/text_message.dart';
import 'package:tecky_chat/theme/colors.dart';

class MessageList extends StatefulWidget {
  final List<Message> messages;
  final ScrollController scrollController;

  const MessageList({Key? key, required this.messages, required this.scrollController})
      : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => previous.user?.id != current.user?.id,
      builder: (context, state) {
        return ListView(
            reverse: true,
            controller: widget.scrollController,
            children: widget.messages
                .asMap()
                .map((index, message) {
                  if (message.type == MessageType.date) {
                    final widget = Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: DateMessage(title: message.textContent));

                    return MapEntry(index, widget);
                  }

                  final isIncoming = message.authorId != state.user?.id;
                  final timeString =
                      DateFormat('HH:mm').format(message.createdAt ?? DateTime.now());
                  final widget = Container(
                      alignment: isIncoming ? Alignment.centerLeft : Alignment.centerRight,
                      child: MessageBubble(
                        footer: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(timeString),
                          const SizedBox(width: 12),
                          if (!isIncoming)
                            AnimatedSwitcher(
                                duration: const Duration(milliseconds: 450),
                                child: message.status == MessageStatus.sending
                                    ? const SizedBox(width: 18)
                                    : const Text('Sent')),
                        ]),
                        direction: isIncoming
                            ? MessageBubbleDirection.incoming
                            : MessageBubbleDirection.outgoing,
                        child: TextMessage(
                          textContent: message.textContent,
                          textColor:
                              isIncoming ? ThemeColors.neutralActive : ThemeColors.neutralWhite,
                        ),
                      ));

                  return MapEntry(index, widget);
                })
                .values
                .toList());
      },
    );
  }
}
