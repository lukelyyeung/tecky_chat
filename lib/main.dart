import 'package:flutter/material.dart';
import 'package:tecky_chat/theme/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatroomScreen(),
    );
  }
}

class ChatroomScreen extends StatefulWidget {
  const ChatroomScreen({Key? key}) : super(key: key);

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  final _messages = [
    'Hello World',
    'Is this your 1st Flutter Application?',
    'Yes. Flutter is really simple and fast.',
    '---',
    'Also, its built-in UI component is so nice.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Row(children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.chevron_left, color: ThemeColors.neutralActive),
          ),
          Text(
            'Athalia Putri',
            style: TextStyle(color: ThemeColors.neutralActive),
          )
        ]),
      ),
      backgroundColor: ThemeColors.neutralSecondary,
      body: Column(children: [
        Expanded(
            child: ListView(
                children: _messages
                    .asMap()
                    .map((index, message) {
                      if (message == '---') {
                        final widget = Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(children: const [
                              SizedBox(width: 16),
                              Expanded(
                                  child: Divider(height: 2, color: ThemeColors.neutralDisabled)),
                              SizedBox(width: 16),
                              Text(
                                'Sat, 17/10',
                                style: TextStyle(color: ThemeColors.neutralDisabled, fontSize: 10),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                  child: Divider(height: 2, color: ThemeColors.neutralDisabled)),
                              SizedBox(width: 16),
                            ]));

                        return MapEntry(index, widget);
                      }

                      final isIncoming = index % 2 == 0;
                      final widget = Container(
                        alignment: isIncoming ? Alignment.centerLeft : Alignment.centerRight,
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .7),
                          margin: EdgeInsets.only(
                              top: 6,
                              bottom: 6,
                              right: isIncoming ? 0 : 16,
                              left: isIncoming ? 16 : 0),
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
                            crossAxisAlignment:
                                isIncoming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                            children: [
                              Text(
                                message,
                                style: TextStyle(
                                    color: isIncoming
                                        ? ThemeColors.neutralActive
                                        : ThemeColors.neutralWhite,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "09:30 · Read",
                                style: TextStyle(
                                    color: isIncoming
                                        ? ThemeColors.neutralActive
                                        : ThemeColors.neutralWhite,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      );

                      return MapEntry(index, widget);
                    })
                    .values
                    .toList())),
        AnimatedSize(
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
        )
      ]),
    );
  }
}
