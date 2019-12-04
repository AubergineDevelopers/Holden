import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HomeProvider with ChangeNotifier {
  String _xlsxFilePath;
  List<List<dynamic>> _xlsxFileData;

  String get xlsxFilePath => this._xlsxFilePath;

  set xlsxFilePath(String _xlsxFilePath) {
    this._xlsxFilePath = _xlsxFilePath;
    notifyListeners();
  }

  List<List<dynamic>> get xlsxFileData => this._xlsxFileData;

  set xlsxFileData(List<List<dynamic>> _xlsxFileData) =>
      this._xlsxFileData = _xlsxFileData;
}
