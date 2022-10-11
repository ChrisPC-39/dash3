import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:firebase_core/firebase_core.dart';

import 'database/item.dart';
import 'database/setup.dart';
import 'database/user.dart';
import 'globals.dart';
import 'screens/main_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(SetupAdapter());

  await setupLocalDB();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ValueListenableBuilder(
      valueListenable: Hive.box(setupBoxName).listenable(),
      builder: (context, setupBox, _) {
        final setup = Hive.box(setupBoxName).getAt(0) as Setup;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: setup.theme == "light"
              ? ThemeData.light()
              : ThemeData.dark().copyWith(
                  colorScheme: ThemeData.dark().colorScheme.copyWith(
                        secondary: Colors.purple[300],
                      ),
                ),
          home: MainScreen(setup: setup),
        );
      },
    );
  }
}

Future<void> setupLocalDB() async {
  var setupBox = await Hive.openBox(setupBoxName);
  var itemBox = await Hive.openBox(itemBoxName);
  var userBox = await Hive.openBox(userBoxName);

  if (setupBox.isEmpty) setupBox.add(dummySetup);
}
