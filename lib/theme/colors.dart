import 'package:flutter/material.dart';

class ThemeColors {
  static const brandDark = Color.fromRGBO(0, 26, 131, 1); // Brand Color/Dark
  static const brandLight = Color.fromRGBO(210, 213, 249, 1); // Brand Color/Default
  static const brandDarkMode = Color.fromRGBO(55, 95, 255, 1); // Brand Color/Dark Mode
  static const brandBackground = Color.fromRGBO(135, 159, 255, 1); // Brand Color/Background
  static const brandDefault = Color.fromRGBO(0, 45, 227, 1); // Brand Color/Light

  static const neutralActive = Color.fromRGBO(15, 24, 40, 1); // Neutral/Active
  static const neutralDark = Color.fromRGBO(21, 32, 51, 1); // Neutral/Dark
  static const neutralBody = Color.fromRGBO(27, 43, 72, 1); // Neutral/Body
  static const neutralWeak = Color.fromRGBO(164, 164, 164, 1); // Neutral/Weak
  static const neutralDisabled = Color.fromRGBO(173, 181, 189, 1); // Neutral/Disabled
  static const neutralLine = Color.fromRGBO(237, 237, 237, 1); // Neutral/Line
  static const neutralSecondary = Color.fromRGBO(247, 247, 252, 1); // Neutral/Secondary
  static const neutralWhite = Color.fromRGBO(255, 255, 255, 1); // Neutral/White
  static const neutralOffWhite = Color.fromRGBO(247, 247, 252, 1); // Neutral/White

  static const danger = Color.fromRGBO(233, 66, 66, 1); // Danger
  static const warning = Color.fromRGBO(253, 207, 65, 1); // Warning
  static const success = Color.fromRGBO(44, 192, 105, 1); // Success
  static const safe = Color.fromRGBO(123, 203, 207, 1); // Safe

  static const brandGradient1 =
      LinearGradient(colors: [Color.fromRGBO(210, 213, 249, 1), Color.fromRGBO(44, 55, 225, 1)]);

  static const brandGradient2 =
      LinearGradient(colors: [Color.fromRGBO(236, 158, 255, 1), Color.fromRGBO(95, 46, 234, 1)]);
}
