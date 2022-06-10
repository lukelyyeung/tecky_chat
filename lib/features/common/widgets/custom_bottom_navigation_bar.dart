import 'package:flutter/material.dart';
import 'package:tecky_chat/theme/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final void Function(int index) onTap;

  const CustomBottomNavigationBar(
      {Key? key, required this.items, required this.currentIndex, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.04), blurRadius: 24, offset: Offset(0, -1))
        ],
        color: ThemeColors.neutralWhite,
      ),
      child: SafeArea(
          bottom: true,
          child: SizedBox(
            height: kBottomNavigationBarHeight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items
                    .asMap()
                    .map((index, item) {
                      final isActive = currentIndex == index;

                      Widget? inner;

                      if (isActive) {
                        inner = Column(
                          key: ValueKey('${item.label}/active'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.label!),
                            const SizedBox(height: 6),
                            const CircleAvatar(
                                backgroundColor: ThemeColors.neutralActive, radius: 2),
                          ],
                        );
                      } else {
                        inner = Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            key: ValueKey('${item.label}/inactive'),
                            children: [item.icon]);
                      }

                      final animatedSwitcher = AnimatedSwitcher(
                        duration: kThemeAnimationDuration,
                        child: inner,
                      );

                      final widget = Expanded(
                          child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => onTap(index),
                              child:
                                  Container(alignment: Alignment.center, child: animatedSwitcher)));

                      return MapEntry(index, widget);
                    })
                    .values
                    .toList()),
          )),
    );
  }
}
