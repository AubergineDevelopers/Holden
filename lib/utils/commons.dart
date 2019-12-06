import 'dart:io';

import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

Future<void> pdfGenerator(name) async {
  final _pdf = pdf.Document();
  final _assetImage = await pdfImageFromImageProvider(
    pdf: _pdf.document,
    image: AssetImage(
      'assets/images/account.png',
    ),
  );
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
                width: 160,
                height: 160,
                decoration: pdf.BoxDecoration(
                  shape: pdf.BoxShape.circle,
                  color: PdfColors.deepPurple200,
                ),
                child: pdf.Image(_assetImage),
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

Future<String> getApplicationDocumentsDirectoryPath() async {
  final Directory applicationDocumentsDirectory =
      await getApplicationDocumentsDirectory();
  return applicationDocumentsDirectory.path;
}
