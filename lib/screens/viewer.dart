import 'package:flutter/material.dart';

import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class ViewerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> view = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate'),
      ),
      body: PdfViewer(
        filePath: view['view'],
      ),
    );
  }
}
