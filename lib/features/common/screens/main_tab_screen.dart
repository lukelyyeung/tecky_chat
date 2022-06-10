import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tecky_chat/features/common/widgets/custom_bottom_navigation_bar.dart';
import 'package:tecky_chat/features/contacts/screens/contact_screen.dart';
import 'package:tecky_chat/theme/colors.dart';

class MainTabScreen extends StatefulWidget {
  final int currentIndex;
  MainTabScreen({Key? key, required String currentTab})
      : currentIndex = MainTabScreen.tabs.indexOf(currentTab),
        super(key: key);

  static const tabs = ['contacts', 'chats', 'settings'];

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: widget.currentIndex, length: 3, vsync: this);
  }

  @override
  void didUpdateWidget(covariant MainTabScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      _tabController.index = widget.currentIndex;
    }
  }

  List<BottomNavigationBarItem> get _bottomNavigationBarItem {
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Contacts'),
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble), label: 'Chats'),
      BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Settings'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: _tabController, children: const [
        ContactScreen(),
        Scaffold(body: Center(child: Text('Chats'))),
        Scaffold(body: Center(child: Text('Settings')))
      ]),
      bottomNavigationBar: AnimatedBuilder(
          animation: _tabController,
          builder: (context, snapshot) {
            return CustomBottomNavigationBar(
              onTap: (index) => context.go('/main?tab=${MainTabScreen.tabs[index]}'),
              currentIndex: _tabController.index,
              items: _bottomNavigationBarItem,
            );
          }),
      backgroundColor: ThemeColors.neutralSecondary,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: ThemeColors.neutralWhite,
          centerTitle: false,
          title: const Text('Contacts', style: TextStyle(color: ThemeColors.neutralActive))),
    );
  }
}
