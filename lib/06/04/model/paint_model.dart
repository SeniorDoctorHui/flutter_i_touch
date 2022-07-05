import 'package:flutter/material.dart';
import 'package:flutter_i_touch/06/04/model/line.dart';
import 'package:flutter_i_touch/06/04/model/point.dart';

class PaintModel extends ChangeNotifier {
  final List<Line> _lines = [];

  Matrix4 _matrix = Matrix4.identity();

  set matrix(Matrix4 value) {
    _matrix = value;
    notifyListeners();
  }

  Matrix4 get matrix => _matrix;

  final double tolerance = 8.0;

  Line get activeLine => _lines.singleWhere((element) => element.state == PaintState.doing);

  Line get editLine => _lines.singleWhere((element) => element.state == PaintState.edit);

  void pushLine(Line line) {
    _lines.add(line);
  }

  List<Line> get lines => _lines;

  void pushPoint(Point point, {bool force = false}) {
    if (activeLine == null) return;

    if (activeLine.points.isNotEmpty && !force) {
      if ((point - activeLine.points.last).distance < tolerance) return;
    }
    activeLine.points.add(point);
    notifyListeners();
  }

  void activeEditLine(Point point) {
    List<Line> lines = _lines.where((line) => line.contains(point.toOffset(), _matrix)).toList();
    if (lines.isNotEmpty) {
      lines[0].state = PaintState.edit;
      lines[0].recode();
      notifyListeners();
    }
  }

  void cancelEditLine() {
    _lines.forEach((element) => element.state = PaintState.done);
    notifyListeners();
  }

  void moveEditLine(Offset offset) {
    if (editLine == null) return;
    editLine.translate(offset, matrix);
    notifyListeners();
  }

  void doneLine() {
    if (activeLine == null) return;
    activeLine.state = PaintState.done;
    notifyListeners();
  }

  void clear() {
    for (var element in _lines) {
      element.points.clear();
    }
    _lines.clear();
    notifyListeners();
  }

  void removeEmpty() {
    _lines.removeWhere((element) => element.points.isEmpty);
  }
}
