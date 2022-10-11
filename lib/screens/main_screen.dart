import 'package:dash3/screens/offline_screen/offline_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../database/setup.dart';
import '../database/user.dart';
import '../globals.dart';
import 'login_screen.dart';
import 'online_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  final Setup setup;

  const MainScreen({Key? key, required this.setup}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(itemBoxName).listenable(),
      builder: (context, itemBox, _) {
        final userBox = Hive.box(userBoxName);

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Column(
              children: [
                Container(height: 50),
                Visibility(
                  visible: widget.setup.showIndicator,
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      activeDotColor: findActiveSecondaryColor(),
                    ), // your preferred effect
                    onDotClicked: (index) => pageController.animateToPage(
                      index,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SettingsScreen(setup: widget.setup),
                      OfflineScreen(setup: widget.setup),
                      userBox.isEmpty
                          ? LoginScreen(setup: widget.setup)
                          : OnlineScreen(setup: widget.setup),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
