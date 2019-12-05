import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HomeProvider with ChangeNotifier {
  String _xlsxFilePath;

  String get xlsxFilePath => this._xlsxFilePath;

  set xlsxFilePath(String _xlsxFilePath) {
    this._xlsxFilePath = _xlsxFilePath;
    notifyListeners();
  }
}
