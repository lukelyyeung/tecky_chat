import 'package:flutter/material.dart';
import 'package:tecky_chat/theme/colors.dart';

enum MessageBubbleDirection {
  incoming,
  outgoing,
}

class MessageBubble extends StatelessWidget {
  final Widget child;
  final MessageBubbleDirection direction;
  final Widget? footer;

  const MessageBubble({
    Key? key,
    required this.child,
    this.direction = MessageBubbleDirection.outgoing,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncoming = direction == MessageBubbleDirection.incoming;

    return Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .7),
        margin: EdgeInsets.only(
            top: 6, bottom: 6, right: isIncoming ? 0 : 16, left: isIncoming ? 16 : 0),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: isIncoming ? Radius.zero : const Radius.circular(16),
            topRight: isIncoming ? const Radius.circular(16) : Radius.zero,
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
          ),
          color: isIncoming ? ThemeColors.neutralWhite : ThemeColors.brandDefault,
        ),
        child: Column(
          crossAxisAlignment: isIncoming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            child,
            const SizedBox(height: 8),
            IconTheme(
              data: IconThemeData(
                  color: isIncoming ? ThemeColors.neutralActive : ThemeColors.neutralWhite),
              child: DefaultTextStyle(
                child: footer ?? const SizedBox.shrink(),
                style: TextStyle(
                    color: isIncoming ? ThemeColors.neutralActive : ThemeColors.neutralWhite,
                    fontSize: 10),
              ),
            ),
          ],
        ));
  }
}
