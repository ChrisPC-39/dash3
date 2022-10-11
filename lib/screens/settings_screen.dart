import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../database/setup.dart';
import '../globals.dart';
import '../widgets/off_item_container.dart';

class SettingsScreen extends StatefulWidget {
  final Setup setup;

  const SettingsScreen({Key? key, required this.setup}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(padding, 0, padding, padding),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const Align(
            alignment: Alignment(-0.8, 0),
            child: Text("Settings", style: TextStyle(fontSize: 35)),
          ),
          const SizedBox(height: padding),
          OffItemContainer(item: dummyItem, index: -1, setup: widget.setup),
          _buildReverseOrder(),
          const SizedBox(height: padding),
          _buildSendByEnter(),
          const SizedBox(height: padding),
          _buildShowIndicator(),
          const SizedBox(height: padding),
          _buildChangeTheme(),
          const SizedBox(height: padding),
          _buildChangeFont(),
          const SizedBox(height: padding),
          _buildChangeContainerSize(),
          const SizedBox(height: padding),
        ],
      ),
    );
  }

  Widget _buildReverseOrder() {
    return SwitchListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      value: widget.setup.reverse,
      activeColor: findActiveSecondaryColor(),
      title: const Text(
        "Reverse button order",
        style: TextStyle(fontSize: 25),
      ),
      onChanged: (value) => Hive.box(setupBoxName).putAt(
        0,
        Setup(
          reverse: value,
          theme: widget.setup.theme,
          useEnter: widget.setup.useEnter,
          boxSize: widget.setup.boxSize,
          textSize: widget.setup.textSize,
          showIndicator: widget.setup.showIndicator,
        ),
      ),
    );
  }

  Widget _buildSendByEnter() {
    return SwitchListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      value: widget.setup.useEnter,
      activeColor: findActiveSecondaryColor(),
      title: const Text("Confirm by Enter", style: TextStyle(fontSize: 25)),
      subtitle: const Text("Add an item by tapping 'Enter' on your keyboard"),
      onChanged: (value) => Hive.box(setupBoxName).putAt(
        0,
        Setup(
          useEnter: value,
          theme: widget.setup.theme,
          reverse: widget.setup.reverse,
          boxSize: widget.setup.boxSize,
          textSize: widget.setup.textSize,
          showIndicator: widget.setup.showIndicator,
        ),
      ),
    );
  }

  Widget _buildShowIndicator() {
    return SwitchListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      value: widget.setup.showIndicator,
      activeColor: findActiveSecondaryColor(),
      title: const Text("Show page indicator", style: TextStyle(fontSize: 25)),
      onChanged: (value) => Hive.box(setupBoxName).putAt(
        0,
        Setup(
          theme: widget.setup.theme,
          reverse: widget.setup.reverse,
          boxSize: widget.setup.boxSize,
          textSize: widget.setup.textSize,
          useEnter: widget.setup.useEnter,
          showIndicator: value,
        ),
      ),
    );
  }

  Widget _buildChangeTheme() {
    return SwitchListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      value: widget.setup.theme != "light",
      activeColor: findActiveSecondaryColor(),
      title: const Text("Enable dark mode", style: TextStyle(fontSize: 25)),
      onChanged: (value) => Hive.box(setupBoxName).putAt(
        0,
        Setup(
          theme: value ? "dark" : "light",
          reverse: widget.setup.reverse,
          useEnter: widget.setup.useEnter,
          boxSize: widget.setup.boxSize,
          textSize: widget.setup.textSize,
          showIndicator: widget.setup.showIndicator,
        ),
      ),
    );
  }

  Widget _buildChangeFont() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Align(
              alignment: Alignment(-1.0, 0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Text(
                  "Change font size",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            MaterialButton(
              child: Column(
                children: const [
                  Icon(Icons.settings_backup_restore_rounded),
                  Text("Default"),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              onPressed: () => Hive.box(setupBoxName).putAt(
                0,
                Setup(
                  theme: widget.setup.theme,
                  reverse: widget.setup.reverse,
                  useEnter: widget.setup.useEnter,
                  boxSize: widget.setup.boxSize,
                  textSize: textSize,
                  showIndicator: widget.setup.showIndicator,
                ),
              ),
            ),
          ],
        ),
        Slider(
          max: 50,
          min: 15,
          divisions: 35,
          activeColor: findActiveSecondaryColor(),
          inactiveColor: Colors.transparent,
          value: widget.setup.textSize,
          label: "${widget.setup.textSize}",
          onChanged: (value) {
            setState(() {});
            Hive.box(setupBoxName).putAt(
              0,
              Setup(
                theme: widget.setup.theme,
                reverse: widget.setup.reverse,
                useEnter: widget.setup.useEnter,
                boxSize: widget.setup.boxSize,
                textSize: value,
                showIndicator: widget.setup.showIndicator,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChangeContainerSize() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Align(
              alignment: Alignment(-1.0, 0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Text(
                  "Change box size",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            MaterialButton(
              child: Column(
                children: const [
                  Icon(Icons.settings_backup_restore_rounded),
                  Text("Default"),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              onPressed: () => Hive.box(setupBoxName).putAt(
                0,
                Setup(
                  theme: widget.setup.theme,
                  reverse: widget.setup.reverse,
                  useEnter: widget.setup.useEnter,
                  boxSize: defaultSize,
                  textSize: widget.setup.textSize,
                  showIndicator: widget.setup.showIndicator,
                ),
              ),
            ),
          ],
        ),
        Slider(
          max: 50,
          min: 0,
          divisions: 50,
          activeColor: findActiveSecondaryColor(),
          inactiveColor: Colors.transparent,
          value: widget.setup.boxSize - 50,
          label: "${widget.setup.boxSize - 50}",
          onChanged: (value) {
            setState(() {});
            Hive.box(setupBoxName).putAt(
              0,
              Setup(
                theme: widget.setup.theme,
                reverse: widget.setup.reverse,
                useEnter: widget.setup.useEnter,
                boxSize: value + 50,
                textSize: widget.setup.textSize,
                showIndicator: widget.setup.showIndicator,
              ),
            );
          },
        ),
      ],
    );
  }
}
