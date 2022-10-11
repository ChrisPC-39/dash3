import 'package:dash3/globals.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../database/item.dart';
import '../database/setup.dart';

class OnTextField extends StatefulWidget {
  final Setup setup;
  final ScrollController scrollController;

  const OnTextField({
    Key? key,
    required this.setup,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<OnTextField> createState() => _OnTextFieldState();
}

class _OnTextFieldState extends State<OnTextField> {
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();

  String input = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: TextField(
        focusNode: focusNode,
        controller: textController,
        textInputAction: widget.setup.useEnter
            ? TextInputAction.done
            : TextInputAction.newline,
        textCapitalization: TextCapitalization.sentences,
        decoration: inputDecoration(),
        onSubmitted: (val) {},
        onChanged: (newVal) => setState(() {
          input = newVal;
        }),
      ),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor:
      widget.setup.theme == "light" ? Colors.grey[300] : Colors.grey[800],
      enabledBorder: outlineBorder(isFocused: false),
      focusedBorder: outlineBorder(isFocused: true),
      suffixIcon: IconButton(
        splashRadius: 1,
        icon: Icon(
          Icons.search,
          color: input.isNotEmpty ? findActiveSecondaryColor() : Colors.grey,
        ),
        onPressed: () {},
      ),
      hintText: "Room code",
      hintStyle: const TextStyle(color: Colors.grey),
    );
  }
}
