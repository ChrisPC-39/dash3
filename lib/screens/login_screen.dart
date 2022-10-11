import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';

import '../database/setup.dart';
import '../database/user.dart';
import '../globals.dart';

class LoginScreen extends StatefulWidget {
  final Setup setup;

  const LoginScreen({Key? key, required this.setup}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool canSignIn = true;

  final TextEditingController nameController = TextEditingController();

  Color pickerColor = Colors.blue[300]!;
  Color currentColor = Colors.blue[300]!;

  @override
  void initState() {
    super.initState();

    final randColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    pickerColor = randColor[300]!;
    currentColor = randColor[300]!;
  }

  @override
  void dispose() {
    nameController.dispose();

    super.dispose();
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            const Text(
              "Set up your account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 25),
            Container(
              height: 225,
              width: 350,
              decoration: BoxDecoration(
                color: widget.setup.theme == "dark"
                    ? Colors.grey[800]
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      "Name",
                    ),
                    const SizedBox(height: 5),
                    Flexible(
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: nameController,
                        decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: outlineBorder(isFocused: true),
                          fillColor: findActiveSecondaryColor(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Flexible(
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("User color"),
                            Icon(Icons.color_lens),
                          ],
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            currentColor,
                          ),
                          fixedSize: MaterialStateProperty.all(
                            const Size(400, 40),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Pick a color!'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: changeColor,
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Got it'),
                                  onPressed: () {
                                    setState(() => currentColor = pickerColor);
                                    // print(currentColor.value);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Flexible(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            findActiveSecondaryColor(),
                          ),
                          fixedSize: MaterialStateProperty.all(
                            const Size(400, 40),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text("Sign in"),
                        onPressed: () => setState(() => signIn()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Visibility(
              visible: !canSignIn,
              child: Container(
                width: 350,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red.withOpacity(0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("No anonymity allowed"),
                      IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => setState(() {
                          canSignIn = true;
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signIn() {
    if (nameController.text.isEmpty) {
      canSignIn = false;
    } else {
      canSignIn = true;

      if (Hive.box(userBoxName).length != 0) {
        for (int i = 0; i < Hive.box(userBoxName).length; i++) {
          Hive.box(userBoxName).deleteAt(i);
        }
      }

      Hive.box(userBoxName).add(
        User(
          name: nameController.text,
          color: currentColor.value,
        ),
      );
      //TODO: change to other page
    }
  }
}
