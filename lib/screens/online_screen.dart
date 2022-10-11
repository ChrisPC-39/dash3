import 'package:dash3/widgets/on_textfield.dart';
import 'package:flutter/material.dart';

import '../database/setup.dart';
import '../globals.dart';

class OnlineScreen extends StatefulWidget {
  final Setup setup;

  const OnlineScreen({Key? key, required this.setup}) : super(key: key);

  @override
  State<OnlineScreen> createState() => _OnlineScreenState();
}

class _OnlineScreenState extends State<OnlineScreen> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: OnTextField(
                setup: widget.setup,
                scrollController: scrollController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: padding),
              child: ElevatedButton(
                child: const Text("Create\nroom", textAlign: TextAlign.center),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    findActiveSecondaryColor(),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
