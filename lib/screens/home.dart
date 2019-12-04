import 'dart:io';

import 'package:flutter/material.dart';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:file_picker/file_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _filePath;
  var _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate Generator'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (_filePath != null) {
                Navigator.pushNamed(context, '/result',
                    arguments: {'result': _result});
              } else {
                showDialog(
                  context: context,
                  builder: (builder) => Dialog(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: Text('Click FAB to read xlsx'),
                    ),
                  ),
                );
              }
            },
            icon: Icon(Icons.remove_red_eye),
          ),
          _filePath != null
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _filePath = null;
                    });
                  },
                  icon: Icon(Icons.close),
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _filePath = await FilePicker.getFilePath(
            type: FileType.CUSTOM,
            fileExtension: 'xlsx',
          );
          setState(() {});
        },
        child: Icon(Icons.attach_file),
      ),
      body: Center(
        child: _filePath != null
            ? FutureBuilder(
                future: DownloadsPathProvider.downloadsDirectory,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    var decoded = SpreadsheetDecoder.decodeBytes(
                        File(_filePath).readAsBytesSync());
                    _result = decoded.tables['Sheet1'].rows;
                    return ListView(
                      children: <Widget>[
                        ...decoded.tables['Sheet1'].rows.map((value) {
                          return ListTile(
                            onTap: () {},
                            title: Text(value
                                .toString()
                                .substring(1, value.toString().length - 1)),
                          );
                        }),
                      ],
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            : Center(
                child: Text('Click FAB to read xlsx'),
              ),
      ),
    );
  }
}
