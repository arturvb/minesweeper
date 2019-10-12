import 'dart:math';

class Minefield {
  int width;
  int height;
  var gameOver = false;
  var gameWon = false;
  List<MinefieldCell> cells = [];

  Minefield(this.width, this.height) {
    for (int i = 0; i < width * height; i++) {
      cells.add(MinefieldCell());
    }
  }

  MinefieldCell getCell(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
      var cell = MinefieldCell();
      cell.isOutsideBoard = true;
      return cell;
    }

    return cells[_cellIndex(y, x)];
  }

  int _cellIndex(int y, int x) => y * height + x;
}


class MinefieldCell {
  var revealed = false;
  var isBomb = false;
  var numberOfNearBombs = 0;
  var flaggedAsBomb = false;
  var isOutsideBoard = false;
}


Minefield createMinefieldModel({int width, int height, int numberOfBombs}) {
  assert(width >= 0);
  assert(height >= 0);
  assert(numberOfBombs >= 0);

  final model = Minefield(width, height);

  _placeBombs(numberOfBombs, width, height, model);
  _computeNearBombs(model, width, height);

  return model;
}


void _computeNearBombs(Minefield model, int width, int height) {
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      if (!model.getCell(x, y).isBomb) {
        model.getCell(x, y).numberOfNearBombs = _countOfNearBombs(model, x, y);
      }
    }
  }
}


int _countOfNearBombs(Minefield model, int x, int y) {
  var foundBombs = 0;

  for (int dx = -1; dx <= 1; dx++) {
    for (int dy = -1; dy <= 1; dy++) {
      if (dx != 0 || dy != 0) {
        var cell = model.getCell(x + dx, y + dy);
        foundBombs += cell.isBomb ? 1 : 0;
      }
    }
  }
  return foundBombs;
}


void _placeBombs(int numberOfBombs, int width, int height, Minefield model) {
  var placedBombs = 0;

  var randomizer = Random();
  while (placedBombs < numberOfBombs) {
    var x = randomizer.nextInt(width);
    var y = randomizer.nextInt(height);
    var cell = model.getCell(x, y);
    if (!cell.isBomb) {
      cell.isBomb = true;
      placedBombs++;
    }
  }
}


Minefield longPressOnCell(Minefield model, int x, int y) {
  if (model.gameOver) {
    return model;
  }

  var cell = model.getCell(x, y);
  if (!cell.revealed) {
    cell.flaggedAsBomb = !cell.flaggedAsBomb;
  }

  return model;
}


Minefield tapOnCell(Minefield model, int x, int y) {
  if (model.gameOver) {
    return model;
  }

  var cell = model.getCell(x, y);
  if (!cell.revealed) {
    cell.revealed = true;

    if (cell.numberOfNearBombs == 0 && !cell.isBomb) {
      _reveilNeightbourThatHasNoBombs(model, x, y, []);
    }

    if (cell.isBomb) {
      model.gameOver = true;
    }
  }

  _checkIfGameIsWon(model);

  return model;
}


void _checkIfGameIsWon(Minefield model) {
  if (!model.gameOver) {
    var revealedCells = model.cells.where((cell) => cell.revealed).length;
    var bombs = model.cells.where((cell) => cell.isBomb).length;

    if (revealedCells + bombs == model.cells.length) {
      model.gameWon = true;

      model.cells.forEach((cell) => cell.revealed = true);
    }
  }
}


void _reveilNeightbourThatHasNoBombs(
  Minefield model, int x, int y, List<String> visitedCells) {
  visitedCells.add("$x $y");

  for (int dx = -1; dx <= 1; dx++) {
    for (int dy = -1; dy <= 1; dy++) {
      if (dx != 0 || dy != 0) {
        var otherCell = model.getCell(x + dx, y + dy);
        otherCell.revealed = true;
        if (otherCell.numberOfNearBombs == 0 &&
          !otherCell.isBomb &&
          !otherCell.isOutsideBoard) {
          if (!visitedCells.contains("${x + dx} ${y + dy}")) {
            _reveilNeightbourThatHasNoBombs(
              model, x + dx, y + dy, visitedCells);
          }
        }
      }
    }
  }
}
