import 'package:flutter/material.dart';
import 'package:tecky_chat/theme/colors.dart';

class ChatroomInput extends StatelessWidget {
  const ChatroomInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: kThemeAnimationDuration,
      child: Container(
        color: ThemeColors.neutralWhite,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SafeArea(
          bottom: true,
          child: Row(children: const [
            SizedBox(width: 48, child: Icon(Icons.add)),
            Expanded(
                child: TextField(
              maxLines: 5,
              minLines: 1,
              cursorColor: ThemeColors.neutralBody,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  isDense: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  filled: true,
                  fillColor: ThemeColors.neutralOffWhite),
            )),
            SizedBox(width: 48, child: Icon(Icons.send)),
          ]),
        ),
      ),
    );
  }
}
