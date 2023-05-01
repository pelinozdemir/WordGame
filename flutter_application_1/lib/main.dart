import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game.dart';
import 'package:flutter_application_1/GameScoreTable.dart';

import 'package:flutter_application_1/models/providers.dart';
import 'package:flutter_application_1/models/providersPoint.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';

import 'models/providersDrop.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WordProvider().createPrefObject();
  await IndexProvider().createPrefObject();
  await PointProvider().createPrefObject();
  await Flame.device.fullScreen();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<WordProvider>(
        create: (BuildContext context) => WordProvider()),
    ChangeNotifierProvider<IndexProvider>(
        create: (BuildContext context) => IndexProvider()),
    ChangeNotifierProvider<PointProvider>(
        create: (BuildContext context) => PointProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/gameui": (context) => GameUI(),
          '/gamescore': (context) => GameScore()
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GameUI());
  }
}
