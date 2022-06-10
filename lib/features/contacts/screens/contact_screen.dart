import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tecky_chat/features/common/widgets/user_item.dart';
import 'package:tecky_chat/features/contacts/models/contact.dart';
import 'package:tecky_chat/theme/colors.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _contacts = [
    Contact(username: 'Luke Yeung', id: 'luke'),
    Contact(username: 'Alex Lau', id: 'alex'),
    Contact(username: 'Gordan Lau', id: 'gordan'),
    Contact(username: 'Michael Fung', id: 'michael'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ThemeColors.neutralWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              for (var contact in _contacts)
                UserItem(
                    onTap: () => context.push('/chats/${contact.username}'),
                    onlineStatus: UserOnlineStatus.online,
                    withDivider: true,
                    displayName: contact.username,
                    subtitle: 'Last online: a few moment ago',
                    imageSrc: "https://picsum.photos/seed/${contact.id}/200/200")
            ],
          ),
        ),
      ),
    );
  }
}
