import 'package:flutter/material.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';
import 'package:tecky_chat/theme/colors.dart';

class ChatroomInput extends StatefulWidget {
  final void Function(Message message) onMessageSend;
  const ChatroomInput({Key? key, required this.onMessageSend}) : super(key: key);

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

    widget.onMessageSend(Message(authorId: 'fake-my-id', textContent: message));
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
              const SizedBox(width: 48, child: Icon(Icons.add)),
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
