import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_flutter/game_controller.dart';
import 'package:learn_flutter/score/index.dart';
import 'gamePanel/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GameController.checkDatabase();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      const MyApp(),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Roboto"),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('2048'),
          ),
          body: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                children: const [ScoreWidget(), GamePanel()],
              )),
        ));
  }
}
