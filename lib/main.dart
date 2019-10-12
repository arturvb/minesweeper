import 'package:flutter_web/material.dart';
import 'minefield.dart';


void main() => runApp(FlutterMinesweeperApp());


class FlutterMinesweeperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Minesweeper",
      home: Scaffold(body: MinefieldGame()),
    );
  }
}


class MinefieldGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MinefieldView(
          width: 9,
          height: 9,
          numberOfBombs: 10,
      )),
    );
  }
}
