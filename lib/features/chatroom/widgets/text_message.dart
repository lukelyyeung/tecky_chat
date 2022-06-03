import 'package:flutter/material.dart';
import 'package:tecky_chat/theme/colors.dart';

class TextMessage extends StatelessWidget {
  final Color textColor;
  final String textContent;
  const TextMessage(
      {Key? key, required this.textContent, this.textColor = ThemeColors.neutralActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textContent,
      style: TextStyle(color: textColor, fontSize: 14),
    );
  }
}
