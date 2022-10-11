import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'database/item.dart';
import 'database/setup.dart';

const double padding = 15;
const String itemBoxName = "item";
const String userBoxName = "user";
const String setupBoxName = "setup2";
const double defaultSize = 80;
const double textSize = defaultSize - 50;

void switchTheme() {
  final setup = Hive.box(setupBoxName).getAt(0) as Setup;

  Hive.box(setupBoxName).putAt(
    0,
    Setup(
      theme: setup.theme == "light" ? "dark" : "light",
      reverse: setup.reverse,
      useEnter: setup.useEnter,
      boxSize: setup.boxSize,
      textSize: setup.textSize,
      showIndicator: setup.showIndicator,
    ),
  );
}

OutlineInputBorder outlineBorder({required bool isFocused}) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: isFocused ? findActiveSecondaryColor() : Colors.transparent,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
  );
}

Color findActiveSecondaryColor() {
  final setup = Hive.box(setupBoxName).getAt(0) as Setup;

  return setup.theme == "light" ? Colors.blue : Colors.purple[300]!;
}

final Setup dummySetup = Setup(
  theme: "light",
  reverse: false,
  useEnter: true,
  textSize: textSize,
  showIndicator: true,
  boxSize: defaultSize,
);

final Item dummyItem = Item(
  content: "Sample item",
  isEditing: false,
  isSelected: false,
);
