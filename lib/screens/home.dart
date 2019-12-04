import 'dart:io';

import 'package:flutter/material.dart';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:provider/provider.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:file_picker/file_picker.dart';

import 'package:certificate_generator/providers/home.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, homeProvider, __) => Scaffold(
        backgroundColor: Colors.deepPurple[400],
        appBar: AppBar(
          title: Text('Holden'),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            homeProvider.xlsxFilePath = await FilePicker.getFilePath(
              type: FileType.CUSTOM,
              fileExtension: 'xlsx',
            );
          },
          child: Icon(Icons.attach_file),
        ),
        body: Center(
          child: homeProvider.xlsxFilePath != null
              ? FutureBuilder(
                  future: DownloadsPathProvider.downloadsDirectory,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      var decoded = SpreadsheetDecoder.decodeBytes(
                          File(homeProvider.xlsxFilePath).readAsBytesSync());
                      homeProvider.xlsxFileData = decoded.tables['Sheet1'].rows;
                      return ListView(
                        padding: EdgeInsets.all(16),
                        children: <Widget>[
                          ...decoded.tables['Sheet1'].rows.map(
                            (value) => Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(16),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/result',
                                          arguments: {'result': value});
                                    },
                                    leading: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          '${value[1]}',
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      value[0],
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'Click FAB to read xlsx',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}
