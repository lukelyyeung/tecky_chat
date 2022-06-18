import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tecky_chat/features/common/widgets/user_item.dart';
import 'package:tecky_chat/features/contacts/blocs/contact_bloc.dart';
import 'package:tecky_chat/theme/colors.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  
  @override
  void initState() {
    super.initState();
    context.read<ContactBloc>().add(ContactRetrieve());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ThemeColors.neutralWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<ContactBloc, ContactState>(builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }

            return ListView(
              children: [
                for (var contact in state.contacts)
                  UserItem(
                      onTap: () => context.push('/chats/${contact.username}'),
                      onlineStatus: UserOnlineStatus.online,
                      withDivider: true,
                      displayName: contact.username,
                      subtitle: 'Last online: a few moment ago',
                      imageSrc: "https://picsum.photos/seed/${contact.id}/200/200")
              ],
            );
          }),
        ),
      ),
    );
  }
}
