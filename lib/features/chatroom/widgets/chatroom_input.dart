import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tecky_chat/theme/colors.dart';

class ChatroomInput extends StatefulWidget {
  final void Function(String textContent) onMessageSend;
  final void Function(List<File> files) onFileSend;
  const ChatroomInput({Key? key, required this.onMessageSend, required this.onFileSend})
      : super(key: key);

  @override
  State<ChatroomInput> createState() => _ChatroomInputState();
}

class _ChatroomInputState extends State<ChatroomInput> {
  // Create a key for accessing Form widget's state
  final _formKey = GlobalKey<FormState>();

  void _sendMessage(String? message) {
    if (message == null) {
      return;
    }

    widget.onMessageSend(message);
    _formKey.currentState?.reset();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AnimatedSize(
        duration: kThemeAnimationDuration,
        child: Container(
          color: ThemeColors.neutralWhite,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SafeArea(
            bottom: true,
            child: Row(children: [
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final imagePicker = ImagePicker();

                    final files = await imagePicker.pickMultiImage();

                    if (files == null) {
                      return;
                    }

                    widget.onFileSend(files.map((file) => File(file.path)).toList());
                  },
                  child: const SizedBox(width: 48, child: Icon(Icons.add))),
              Expanded(
                  child: TextFormField(
                validator: (value) {
                  if (value?.isNotEmpty != true) {
                    return "Enter text here";
                  } else {
                    return null;
                  }
                },
                onSaved: _sendMessage,
                maxLines: 5,
                minLines: 1,
                cursorColor: ThemeColors.neutralBody,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    isDense: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    filled: true,
                    fillColor: ThemeColors.neutralOffWhite),
              )),
              GestureDetector(
                  onTap: () {
                    if (_formKey.currentState?.validate() == true) {
                      _formKey.currentState?.save();
                    }
                  },
                  child: const SizedBox(width: 48, child: Icon(Icons.send))),
            ]),
          ),
        ),
      ),
    );
  }
}
