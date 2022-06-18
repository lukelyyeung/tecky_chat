import 'package:flutter/material.dart';
import 'package:tecky_chat/theme/colors.dart';

class TeckyChatTheme {
  static const textFieldInputDecoration = InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      isDense: true,
      border: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(4))),
      filled: true,
      fillColor: ThemeColors.neutralOffWhite);
}