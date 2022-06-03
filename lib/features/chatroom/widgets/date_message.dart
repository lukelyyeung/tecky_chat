import 'package:flutter/material.dart';
import 'package:tecky_chat/theme/colors.dart';

class DateMessage extends StatelessWidget {
  final String title;

  const DateMessage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 16),
      const Expanded(child: Divider(height: 2, color: ThemeColors.neutralDisabled)),
      const SizedBox(width: 16),
      Text(
        title,
        style: const TextStyle(color: ThemeColors.neutralDisabled, fontSize: 10),
      ),
      const SizedBox(width: 16),
      const Expanded(child: Divider(height: 2, color: ThemeColors.neutralDisabled)),
      const SizedBox(width: 16),
    ]);
  }
}
