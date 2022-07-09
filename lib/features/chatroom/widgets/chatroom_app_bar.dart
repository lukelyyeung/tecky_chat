import 'package:flutter/material.dart';
import 'package:tecky_chat/theme/colors.dart';

class ChatroomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ChatroomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: ThemeColors.neutralWhite,
      elevation: 0,
      centerTitle: false,
      actions: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: const Icon(
            Icons.search,
            color: ThemeColors.neutralActive,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: const Icon(
            Icons.menu,
            color: ThemeColors.neutralActive,
          ),
        ),
        const SizedBox(width: 16)
      ],
      title: Row(children: [
        GestureDetector(
          onTap: Navigator.of(context).pop,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.chevron_left, color: ThemeColors.neutralActive),
          ),
        ),
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: ThemeColors.neutralActive),
          ),
        )
      ]),
    );
  }
}
