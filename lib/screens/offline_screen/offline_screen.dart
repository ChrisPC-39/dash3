import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../database/item.dart';
import '../../database/setup.dart';
import '../../globals.dart';
import '../../widgets/off_item_container.dart';
import '../../widgets/off_textfield.dart';
import 'backend.dart';

class OfflineScreen extends StatefulWidget {
  final Setup setup;

  const OfflineScreen({Key? key, required this.setup}) : super(key: key);

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  ScrollController scrollController = ScrollController();

  String textFieldCallback = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: ReorderableListView.builder(
            onReorder: (oldIndex, newIndex) => setState(() {
              onReorder(oldIndex, newIndex);
            }),
            physics: const BouncingScrollPhysics(),
            scrollController: scrollController,
            itemCount: Hive.box(itemBoxName).length,
            itemBuilder: (context, index) {
              if (Hive.box(itemBoxName).isEmpty) {
                return Container();
              }

              final item = Hive.box(itemBoxName).getAt(index) as Item;

              return OffItemContainer(
                key: ValueKey(item),
                item: item,
                index: index,
                setup: widget.setup,
              );
            },
          ),
        ),
        Row(
          children: [
            Flexible(
              child: OffTextField(
                setup: widget.setup,
                scrollController: scrollController,
                callback: (val) => setState(() => textFieldCallback = val),
              ),
            ),
            PopupMenuButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              itemBuilder: (context) => [
                _popupMenuItem(
                  Icons.check_box_outlined,
                  "Clear selection",
                  clearSelection,
                ),
                _popupMenuItem(
                  Icons.sort,
                  "Reorder selection",
                  reorderSelection,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  PopupMenuItem _popupMenuItem(IconData icon, String text, Function onTap) {
    return PopupMenuItem(
      onTap: () => onTap(),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }
}
