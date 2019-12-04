import 'dart:io';

import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> result = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.deepPurple[400],
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
          ),
        ),
        title: Container(
          child: Text('Result'),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(64),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        '${result['result'][1]}',
                        height: 50,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    result['result'][0],
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            color: Colors.deepPurple[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: Image.network(
                      '${result['result'][1]}',
                      height: 150,
                      width: 150,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.deepPurple,
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'certificate of completion',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'presented to:',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  result['result'][0],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        pdfGenerator(result['result'][0]);
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${result['result'][0]}.pdf downloaded'),
                            action: SnackBarAction(
                              label: 'View',
                              onPressed: () async {
                                Directory downloadPath =
                                    await getApplicationDocumentsDirectory();
                                Navigator.pushNamed(context, '/viewer',
                                    arguments: {
                                      'view':
                                          '${downloadPath.path}/${result['result'][0]}.pdf'
                                    });
                              },
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.file_download),
                    ),
                    FlatButton(
                      onPressed: () async {
                        Directory downloadPath =
                            await getApplicationDocumentsDirectory();
                        if (File(
                                '${downloadPath.path}/${result['result'][0]}.pdf')
                            .existsSync()) {
                          Navigator.pushNamed(context, '/viewer', arguments: {
                            'view':
                                '${downloadPath.path}/${result['result'][0]}.pdf'
                          });
                        } else {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${result['result'][0]} File Not Found'),
                              action: SnackBarAction(
                                label: 'Download',
                                onPressed: () {
                                  pdfGenerator(result['result'][0]);
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${result['result'][0]}.pdf downloaded'),
                                      action: SnackBarAction(
                                        label: 'View',
                                        onPressed: () async {
                                          Directory downloadPath =
                                              await getApplicationDocumentsDirectory();
                                          Navigator.pushNamed(
                                              context, '/viewer', arguments: {
                                            'view':
                                                '${downloadPath.path}/${result['result'][0]}.pdf'
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                      child: Icon(Icons.open_in_new),
                    ),
                    FlatButton(
                      onPressed: () async {
                        Directory downloadPath =
                            await getApplicationDocumentsDirectory();
                        if (File(
                                '${downloadPath.path}/${result['result'][0]}.pdf')
                            .existsSync()) {
                          ShareExtend.share(
                              File('${downloadPath.path}/${result['result'][0]}.pdf')
                                  .path,
                              'file');
                        } else {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${result['result'][0]} File Not Found'),
                              action: SnackBarAction(
                                label: 'Download',
                                onPressed: () {
                                  pdfGenerator(result['result'][0]);
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${result['result'][0]}.pdf downloaded'),
                                      action: SnackBarAction(
                                        label: 'View',
                                        onPressed: () async {
                                          Directory downloadPath =
                                              await getApplicationDocumentsDirectory();
                                          Navigator.pushNamed(
                                              context, '/viewer', arguments: {
                                            'view':
                                                '${downloadPath.path}/${result['result'][0]}.pdf'
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                      child: Icon(Icons.share),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pdfGenerator(name) async {
    final _pdf = pdf.Document();
    _pdf.addPage(
      pdf.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pdf.Center(
          child: pdf.Container(
            margin: pdf.EdgeInsets.all(16),
            width: double.maxFinite,
            color: PdfColors.deepPurple50,
            child: pdf.Column(
              mainAxisAlignment: pdf.MainAxisAlignment.center,
              crossAxisAlignment: pdf.CrossAxisAlignment.center,
              children: [
                pdf.SizedBox(
                  height: 50,
                ),
                pdf.Container(
                  padding: pdf.EdgeInsets.all(40),
                  child: pdf.FlutterLogo(),
                  decoration: pdf.BoxDecoration(
                    border: pdf.BoxBorder(
                      color: PdfColors.grey500,
                      width: 5,
                    ),
                    shape: pdf.BoxShape.circle,
                    color: PdfColors.grey300,
                  ),
                ),
                pdf.SizedBox(
                  height: 50,
                ),
                pdf.Text(
                  'certificate of completion',
                  style: pdf.TextStyle(
                    fontSize: 22,
                    color: PdfColors.grey700,
                  ),
                ),
                pdf.SizedBox(
                  height: 20,
                ),
                pdf.Text(
                  'presented to:',
                  style: pdf.TextStyle(
                    color: PdfColors.grey600,
                  ),
                ),
                pdf.SizedBox(
                  height: 30,
                ),
                pdf.Text(
                  name,
                  style: pdf.TextStyle(
                    fontSize: 24,
                    fontWeight: pdf.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    var path = await getApplicationDocumentsDirectory();
    File('${path.path}/$name.pdf').writeAsBytesSync(_pdf.save());
  }
}
