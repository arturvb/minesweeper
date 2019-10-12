import 'package:flutter_web/material.dart';
import 'game-model.dart';


class MinefieldView extends StatefulWidget {
  final int width;
  final int height;
  final int numberOfBombs;

  MinefieldView({this.width, this.height, this.numberOfBombs});

  @override
  _MinefieldViewState createState() => _MinefieldViewState();
}


class _MinefieldViewState extends State<MinefieldView> {
  Minefield model;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    model = createMinefieldModel(
      width: widget.width,
      height: widget.height,
      numberOfBombs: widget.numberOfBombs);
  }

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return Container();
    }

    List<Widget> columns = [];

    for (int y = 0; y < widget.height; y++) {
      List<Widget> row = [];

      for (int x = 0; x < widget.width; x++) {
        row.add(Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                    model = tapOnCell(model, x, y);
                });
              },
              onLongPress: () {
                setState(() {
                    model = longPressOnCell(model, x, y);
                });
              },
              child: Cell(model.getCell(x, y))),
        ));
      }

      columns.add(Row(
          children: row,
      ));
    }

    if (model.gameOver) {
      columns.add(Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Game Over!",
                style: TextStyle(fontSize: 20, color: Colors.red))
            ],
          ),
      ));
    }

    if (model.gameWon) {
      columns.add(Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Great Job!",
                style: TextStyle(fontSize: 20, color: Colors.green))
            ],
          ),
      ));
    }

    columns.add(Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MaterialButton(
              child: Text("Restart Game"),
              color: Colors.green,
              onPressed: () {
                setState(() {
                    _resetGame();
                });
              },
            )
          ],
        ),
    ));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: columns,
      ),
    );
  }
}


class Cell extends StatelessWidget {
  final MinefieldCell cell;

  Cell(this.cell);

  @override
  Widget build(BuildContext context) {
    var textContent = "";
    Color color = Colors.blue.shade500;

    if (cell.revealed) {
      color = Colors.grey.shade300;
    }

    if (cell.flaggedAsBomb) {
      textContent = "?";
      color = Colors.purpleAccent.shade400;
    }

    if (cell.revealed && cell.isBomb) {
      color = Colors.red.shade500;
      textContent = "B";
    }

    if (cell.revealed && cell.numberOfNearBombs > 0) {
      textContent = cell.numberOfNearBombs.toString();
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(1, 1, 0, 0),
        child: Container(
          child: Center(
            child: Text(
              textContent,
              style: TextStyle(fontSize: 20),
          )),
          color: color,
        ),
      ),
    );
  }
}
