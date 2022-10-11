import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../database/item.dart';
import '../database/setup.dart';
import '../globals.dart';

class OffItemContainer extends StatefulWidget {
  final Item item;
  final int index;
  final Setup setup;

  const OffItemContainer({
    Key? key,
    required this.item,
    required this.index,
    required this.setup,
  }) : super(key: key);

  @override
  State<OffItemContainer> createState() => _OffItemContainerState();
}

class _OffItemContainerState extends State<OffItemContainer> {
  FocusNode editNode = FocusNode();
  TextEditingController editController = TextEditingController();

  String editInput = "";

  @override
  void initState() {
    super.initState();

    editController.text = widget.item.content;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(padding, 0, padding, 10),
      constraints: BoxConstraints(minHeight: widget.setup.boxSize),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: widget.item.isSelected
            ? widget.setup.theme == "dark"
                ? Colors.grey[900]
                : Colors.grey[400]
            : widget.setup.theme == "dark"
                ? Colors.grey[800]
                : Colors.grey[200],
      ),
      child: _buildRow(
        Transform.scale(
          scale: widget.setup.textSize / textSize,
          child: Checkbox(
            activeColor: findActiveSecondaryColor(),
            value: widget.item.isSelected,
            onChanged: (value) => Hive.box(itemBoxName).putAt(
              widget.index,
              Item(
                content: widget.item.content,
                isEditing: widget.item.isEditing,
                isSelected: value!,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => initItemEdit(widget.index, widget.item),
            child: !widget.item.isEditing
                ? Text(
                    widget.item.content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.setup.textSize,
                      decoration: widget.item.isSelected
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  )
                : TextField(
                    autofocus: true,
                    textInputAction: widget.setup.useEnter
                        ? TextInputAction.done
                        : TextInputAction.newline,
                    onSubmitted: (value) {
                      if (widget.item.isEditing) updateItem();
                    },
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: widget.setup.textSize),
                    focusNode: editNode,
                    controller: editController,
                    onChanged: (value) => setState(() => editInput = value),
                  ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (widget.item.isEditing) {
              updateItem();
            } else {
              Hive.box(itemBoxName).deleteAt(widget.index);
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
              right: widget.setup.reverse ? 0 : padding,
              left: widget.setup.reverse ? padding : 0,
            ),
            child: Icon(
              widget.item.isEditing
                  ? Icons.check
                  : Icons.delete_outline_rounded,
              size: widget.setup.textSize,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(Widget leftWidget, Widget centerWidget, Widget rightWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.setup.reverse ? rightWidget : leftWidget,
        centerWidget,
        widget.setup.reverse ? leftWidget : rightWidget,
      ],
    );
  }

  void updateItem() {
    editNode.unfocus();

    Hive.box(itemBoxName).putAt(
      widget.index,
      Item(
        content: editInput.isEmpty ? widget.item.content : editInput,
        isEditing: false,
        isSelected: widget.item.isSelected,
      ),
    );

    editController.text = "";
  }

  void initItemEdit(int index, Item item) {
    for (int i = 0; i < Hive.box(itemBoxName).length; i++) {
      final forItem = Hive.box(itemBoxName).getAt(i) as Item;

      Hive.box(itemBoxName).putAt(
        i,
        Item(
          isSelected: forItem.isSelected,
          content: forItem.content,
          isEditing: false,
        ),
      );
    }

    editNode.requestFocus();
    editController.text = item.content;

    Hive.box(itemBoxName).putAt(
      index,
      Item(
        isSelected: item.isSelected,
        isEditing: true,
        content: item.content,
      ),
    );
  }
}
