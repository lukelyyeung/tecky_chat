import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/auth/blocs/auth_bloc.dart';
import 'package:tecky_chat/features/auth/blocs/auth_state.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';
import 'package:tecky_chat/features/chatroom/widgets/date_message.dart';
import 'package:tecky_chat/features/chatroom/widgets/message_bubble.dart';
import 'package:tecky_chat/features/chatroom/widgets/text_message.dart';
import 'package:tecky_chat/theme/colors.dart';
import 'package:intl/intl.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController scrollController;

  const MessageList({Key? key, required this.messages, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ListView(
            controller: scrollController,
            reverse: true,
            children: messages
                .asMap()
                .map((index, message) {
                  if (message.type == MessageType.date) {
                    final widget = Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: DateMessage(title: message.textContent));

                    return MapEntry(index, widget);
                  }

                  final isIncoming = message.authorId != state.user?.id;
                  final footer =
                      '${DateFormat('HH:mm').format(message.createdAt ?? DateTime.now())}・Sent';
                  final direction = isIncoming
                      ? MessageBubbleDirection.incoming
                      : MessageBubbleDirection.outgoing;

                  if (message.type == MessageType.image) {
                    final isUploading = message.mediaFiles.isEmpty;
                    final isError = message.status == MessageStatus.error;

                    if (message.authorId != state.user!.id && (isUploading || isError)) {
                      return MapEntry(index, const SizedBox.shrink());
                    }

                    final widget = Container(
                        alignment: isIncoming ? Alignment.centerLeft : Alignment.centerRight,
                        child: MessageBubble(
                          footer: footer,
                          direction: direction,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (_, __) {
                                  return Container(
                                      color: ThemeColors.neutralSecondary,
                                      child: const CupertinoActivityIndicator());
                                },
                                errorWidget: (_, __, ___) {
                                  return Container(
                                      color: ThemeColors.neutralSecondary,
                                      child: isUploading
                                          ? const CupertinoActivityIndicator()
                                          : const Icon(
                                              Icons.error,
                                              color: ThemeColors.neutralWhite,
                                            ));
                                },
                                imageUrl: isUploading ? '' : message.mediaFiles.first),
                          ),
                        ));

                    return MapEntry(index, widget);
                  }

                  final widget = Container(
                      alignment: isIncoming ? Alignment.centerLeft : Alignment.centerRight,
                      child: MessageBubble(
                        footer: footer,
                        direction: direction,
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
