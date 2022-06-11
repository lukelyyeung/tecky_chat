import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tecky_chat/features/auth/blocs/auth_bloc.dart';
import 'package:tecky_chat/features/auth/blocs/auth_state.dart';
import 'package:tecky_chat/theme/colors.dart';

class Setting {
  final IconData iconData;
  final String title;
  final String settingName;

  const Setting({
    required this.iconData,
    required this.title,
    required this.settingName,
  });
}

// const naming convention for dart
const kSettings = [
  Setting(title: 'Account', settingName: 'account', iconData: Icons.person_outline),
  Setting(title: 'Chats', settingName: 'chats', iconData: CupertinoIcons.chat_bubble),
  Setting(title: 'Appearance', settingName: 'appearance', iconData: Icons.wb_sunny_outlined),
  Setting(title: 'Notification', settingName: 'notification', iconData: Icons.person),
  Setting(title: 'Privacy', settingName: 'privacy', iconData: Icons.privacy_tip_outlined),
  Setting(title: 'Data Usage', settingName: 'dataUsage', iconData: Icons.folder_outlined),
  Setting(title: 'Help', settingName: 'help', iconData: Icons.help_outline),
  Setting(
      title: 'Invite Your Friends',
      settingName: 'inviteYourFriends',
      iconData: Icons.email_outlined),
];

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // No subscription
    // final authBloc = context.read<AuthBloc>();

    return Container(
      color: ThemeColors.neutralWhite,
      child: ListView(
        children: [
          // Image.xxx vs XXXImage
          // Former is widget
          // Latter is Class to provide Image
          ListTile(
            title: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              return Text(state.user?.displayName ?? '');
            }),
            subtitle: Text('+85253732650'),
            trailing: Icon(Icons.chevron_right),
            leading: CircleAvatar(
                radius: 36, backgroundImage: NetworkImage('https://picsum.photos/200/200')),
          ),
          ...kSettings.map((setting) {
            return ListTile(
              onTap: () => context.push('/settings/${setting.settingName}', extra: setting.title),
              title: Row(
                children: [
                  Icon(setting.iconData),
                  const SizedBox(width: 6),
                  Text(setting.title),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
            );
          })
        ],
      ),
    );
  }
}
