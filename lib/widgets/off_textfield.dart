import 'package:dash3/globals.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../database/item.dart';
import '../database/setup.dart';

typedef void StringCallback(String val);

class OffTextField extends StatefulWidget {
  final Setup setup;
  final ScrollController scrollController;
  final StringCallback callback;

  const OffTextField({
    Key? key,
    required this.setup,
    required this.scrollController,
    required this.callback,
  }) : super(key: key);

  @override
  State<OffTextField> createState() => _OffTextFieldState();
}

class _OffTextFieldState extends State<OffTextField> {
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
        onSubmitted: (val) => onItemSubmitted(),
        onChanged: (newVal) => setState(() {
          input = newVal;
          widget.callback(newVal);
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
          Icons.send,
          color: input.isNotEmpty ? findActiveSecondaryColor() : Colors.grey,
        ),
        onPressed: onItemSubmitted,
      ),
      hintText: "Add an item",
      hintStyle: const TextStyle(color: Colors.grey),
    );
  }

  void onItemSubmitted() {
    if (input.isEmpty) return;

    addItemToDB();
    input = "";
    widget.callback("");
    textController.clear();
    focusNode.requestFocus();

    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  void addItemToDB() {
    final itemBox = Hive.box(itemBoxName);
    final newItem = Item(
      content: input,
      isEditing: false,
      isSelected: false,
    );

    itemBox.add(newItem);
    for (int i = itemBox.length - 1; i > 0; i--) {
      final prevItem = itemBox.getAt(i - 1) as Item;
      itemBox.putAt(i, prevItem);
    }

    itemBox.putAt(0, newItem);
  }
}
