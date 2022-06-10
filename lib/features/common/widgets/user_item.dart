import 'package:flutter/material.dart';
import 'package:tecky_chat/theme/colors.dart';

enum UserOnlineStatus {
  online,
  offline,
  busy,
  away,
}

class UserItem extends StatelessWidget {
  final String displayName;
  final String imageSrc;
  final String subtitle;
  final String? timeString;
  final int? unreadCount;
  final bool withDivider;
  final bool withOutline;
  final VoidCallback? onTap;
  final UserOnlineStatus? onlineStatus;

  const UserItem({
    Key? key,
    required this.displayName,
    required this.subtitle,
    required this.imageSrc,
    this.onTap,
    this.timeString,
    this.unreadCount,
    this.withDivider = false,
    this.withOutline = false,
    this.onlineStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(vertical: 6),
          leading: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: withOutline
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: ThemeColors.brandGradient1)
                    : null,
                padding: const EdgeInsets.all(1.5),
                child: Container(
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    child: Image.network(imageSrc),
                  ),
                  padding: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                      color: ThemeColors.neutralWhite, borderRadius: BorderRadius.circular(17)),
                ),
              ),
              if (onlineStatus != null)
                const Positioned(
                  top: -1,
                  right: -1,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 8,
                    child: CircleAvatar(
                      backgroundColor: ThemeColors.success,
                      radius: 6,
                    ),
                  ),
                )
            ],
          ),
          title: Row(
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(displayName),
              if (timeString != null)
                Text(
                  timeString!,
                  style: const TextStyle(fontSize: 12, color: ThemeColors.neutralWeak),
                ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              textBaseline: TextBaseline.ideographic,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subtitle),
                if (unreadCount != null)
                  Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: ThemeColors.brandBackground),
                    child: Text(unreadCount! > 99 ? '99+' : '$unreadCount',
                        style: const TextStyle(color: ThemeColors.neutralWhite, fontSize: 12)),
                  ),
              ],
            ),
          ),
        ),
        if (withDivider == true)
          const Divider(
            thickness: 1,
            height: 1,
            color: ThemeColors.neutralLine,
          )
      ],
    );
  }
}