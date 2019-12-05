import 'dart:io';

import 'package:flutter/material.dart';

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
              ? ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    ...SpreadsheetDecoder.decodeBytes(
                            File(homeProvider.xlsxFilePath).readAsBytesSync())
                        .tables['Sheet1']
                        .rows
                        .map(
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
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.deepPurple[200],
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.deepPurple[100],
                                      size: 30,
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
