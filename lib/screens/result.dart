import 'dart:io';

import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_extend/share_extend.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> result = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificates'),
      ),
      body: Builder(
        builder: (context) => ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            ...result['result'].map(
              (name) => Container(
                margin: EdgeInsets.all(16),
                color: Colors.indigo[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: EdgeInsets.all(40),
                      child: FlutterLogo(
                        size: 50,
                        colors: Colors.indigo,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[500],
                          width: 5,
                        ),
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
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
                      name.toString().substring(1, name.toString().length - 1),
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
                            pdfGenerator(name);
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$name.pdf downloaded'),
                                action: SnackBarAction(
                                  label: 'View',
                                  onPressed: () async {
                                    Directory downloadPath =
                                        await getApplicationDocumentsDirectory();
                                    Navigator.pushNamed(context, '/viewer',
                                        arguments: {
                                          'view': '${downloadPath.path}/$name.pdf'
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
                            if (File('${downloadPath.path}/$name.pdf')
                                .existsSync()) {
                              Navigator.pushNamed(context, '/viewer',
                                  arguments: {
                                    'view': '${downloadPath.path}/$name.pdf'
                                  });
                            } else {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$name File Not Found'),
                                  action: SnackBarAction(
                                    label: 'Download',
                                    onPressed: () {
                                      pdfGenerator(name);
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('$name.pdf downloaded'),
                                          action: SnackBarAction(
                                            label: 'View',
                                            onPressed: () async {
                                              Directory downloadPath =
                                              await getApplicationDocumentsDirectory();
                                              Navigator.pushNamed(context, '/viewer',
                                                  arguments: {
                                                    'view': '${downloadPath.path}/$name.pdf'
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
                            if (File('${downloadPath.path}/$name.pdf')
                                .existsSync()) {
                              ShareExtend.share(
                                  File('${downloadPath.path}/$name.pdf').path,
                                  'file');
                            } else {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$name File Not Found'),
                                  action: SnackBarAction(
                                    label: 'Download',
                                    onPressed: () {
                                      pdfGenerator(name);
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('$name.pdf downloaded'),
                                          action: SnackBarAction(
                                            label: 'View',
                                            onPressed: () async {
                                              Directory downloadPath =
                                              await getApplicationDocumentsDirectory();
                                              Navigator.pushNamed(context, '/viewer',
                                                  arguments: {
                                                    'view': '${downloadPath.path}/$name.pdf'
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
                  ],
                ),
              ),
            ),
          ],
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
            color: PdfColors.indigo50,
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
                  name.toString().substring(1, name.toString().length - 1),
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

  @override
  void initState() {
    super.initState();
    setup();
  }

  void setup() async {
    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  }
}
