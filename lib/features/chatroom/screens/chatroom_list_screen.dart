import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tecky_chat/features/chatroom/blocs/chatroom_bloc.dart';
import 'package:tecky_chat/features/common/widgets/user_item.dart';
import 'package:tecky_chat/theme/colors.dart';

class ChatroomListScreen extends StatefulWidget {
  const ChatroomListScreen({Key? key}) : super(key: key);

  @override
  State<ChatroomListScreen> createState() => _ChatroomListScreenState();
}

class _ChatroomListScreenState extends State<ChatroomListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ThemeColors.neutralWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<ChatroomBloc, ChatroomState>(builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }

            return ListView(
              children: [
                for (var chatroom in state.chatrooms)
                  UserItem(
                      onTap: () => context.push('/chats/${chatroom.id}'),
                      onlineStatus: UserOnlineStatus.online,
                      displayName: chatroom.displayName,
                      subtitle: 'Last online: a few moment ago',
                      imageSrc: "https://picsum.photos/seed/${chatroom.id}/200/200")
              ],
            );
          }),
        ),
      ),
    );
  }
}
