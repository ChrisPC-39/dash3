import 'package:hive/hive.dart';

import '../../database/item.dart';
import '../../globals.dart';

void onReorder(int oldIndex, int newIndex) {
  final index = newIndex > oldIndex ? newIndex - 1 : newIndex;

  final item = Hive.box(itemBoxName).getAt(oldIndex) as Item;
  Hive.box(itemBoxName).deleteAt(oldIndex);

  hiveItemBoxInsertAt(index, item);
}

Future<void> hiveItemBoxInsertAt(int index, Item item) async {
  final itemList = Hive.box(itemBoxName).values.toList();

  itemList.insert(index, item);
  await Hive.box(itemBoxName).clear();

  for (int i = 0; i < itemList.length; i++) {
    Hive.box(itemBoxName).add(itemList[i]);
  }
}

void clearSelection() {
  for (int i = 0; i < Hive.box(itemBoxName).length; i++) {
    final tmp = Hive.box(itemBoxName).getAt(i) as Item;

    if (tmp.isSelected) {
      Hive.box(itemBoxName).deleteAt(i);
    }
  }
}

Future<void> reorderSelection() async {
  final itemList = Hive.box(itemBoxName).values.toList();

  for (int i = 0; i < Hive.box(itemBoxName).length; i++) {
    final tmp = Hive.box(itemBoxName).getAt(i) as Item;

    if (tmp.isSelected) {
      itemList.remove(tmp);
      itemList.add(tmp);
    }
  }

  await Hive.box(itemBoxName).clear();

  for (int i = 0; i < itemList.length; i++) {
    Hive.box(itemBoxName).add(itemList[i]);
  }
}