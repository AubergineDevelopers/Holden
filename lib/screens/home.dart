import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

import 'package:certificate_generator/providers/home.dart';
import 'package:certificate_generator/utils/commons.dart';

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
          bottom: homeProvider.xlsxFilePath != null
              // shows drop-down populated with tables from selected xlsx file
              ? PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    child: DropdownButtonFormField(
                      value: homeProvider.xlsxFileSelectedTable,
                      onChanged: (newXlsxFileSelectedTable) {
                        homeProvider.xlsxFileSelectedTable =
                            newXlsxFileSelectedTable;
                      },
                      items: [
                        ...homeProvider.xlsxFileTables.keys.map(
                          (table) => DropdownMenuItem(
                            child: Text(table),
                            value: table,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : PreferredSize(
                  child: Container(),
                  preferredSize: Size.fromHeight(0),
                ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            homeProvider.xlsxFilePath != null
                ? FloatingActionButton(
                    heroTag: 'Share',
                    onPressed: () async {
                      // retrieves all names from selected table
                      final names = homeProvider
                          .xlsxFileTables[homeProvider.xlsxFileSelectedTable]
                          .rows
                          .map((name) => name
                              .toString()
                              .substring(1, name.toString().length - 1));

                      // generates all certificates from selected table
                      names.forEach((name) => pdfGenerator(name));
                      final String downloadPath =
                          await getApplicationDocumentsDirectoryPath();

                      // retrieves file paths of all certificates from selected table
                      final files = names
                          .map((name) => File('$downloadPath/$name.pdf').path);

                      // shares all certificate from table via selected app
                      await ShareExtend.shareMultiple([
                        ...files,
                      ], 'file');
                    },
                    child: Icon(Icons.share),
                  )
                : Container(),
            SizedBox(
              height: 30,
            ),
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.insert_link),
            ),
            SizedBox(
              height: 30,
            ),
            FloatingActionButton(
              heroTag: 'Attach',
              onPressed: () async {
                homeProvider.xlsxFilePath = await FilePicker.getFilePath(
                  type: FileType.CUSTOM,
                  fileExtension: 'xlsx',
                );
                homeProvider.xlsxFileTables = SpreadsheetDecoder.decodeBytes(
                        File(homeProvider.xlsxFilePath).readAsBytesSync())
                    .tables;
              },
              child: Icon(Icons.attach_file),
            ),
          ],
        ),
        body: Center(
          child: homeProvider.xlsxFilePath != null
              ? ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    // reads names from selected table from spreadsheet and displays them in list
                    ...SpreadsheetDecoder.decodeBytes(
                            File(homeProvider.xlsxFilePath).readAsBytesSync())
                        .tables[homeProvider.xlsxFileSelectedTable]
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
                                  subtitle: Text(
                                    'Tap to view more',
                                    style: TextStyle(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  trailing: FutureBuilder(
                                    future:
                                        getApplicationDocumentsDirectoryPath(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        // shows download icon if file doesn't exist else shows checked icon
                                        return Container(
                                          margin: EdgeInsets.all(8),
                                          child:
                                              File('${snapshot.data}/${value.toString().substring(1, value.toString().length - 1)}.pdf')
                                                      .existsSync()
                                                  ? Icon(
                                                      Icons.check,
                                                      color: Colors.white70,
                                                    )
                                                  : Icon(
                                                      Icons.file_download,
                                                      color: Colors.white70,
                                                    ),
                                        );
                                      }
                                      return CircularProgressIndicator();
                                    },
                                  ),
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
