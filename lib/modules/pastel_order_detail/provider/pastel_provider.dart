import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PastelProvider with ChangeNotifier {
  //1 normal
  //2 cursiva
  //3 negrita
  int _btnStyleText = 1;
  int get btnStyleText => _btnStyleText;

  Color _color = Colors.pinkAccent;
  Color get color => _color;

  set btnStyleText(int i) {
    _btnStyleText = i;
    notifyListeners();
  }

  set color(Color colorSend) {
    _color = colorSend;
    notifyListeners();
  }
}
