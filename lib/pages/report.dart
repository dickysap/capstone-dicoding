import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Reportt extends StatelessWidget {
  String name;
  String subject1;
  String subject2;

  Reportt(
      {super.key,
      required this.name,
      required this.subject1,
      required this.subject2});
  final pdf = pw.Document();

  void initState() {
    name = name;
    subject1 = subject1;
    subject2 = subject2;
  }

  void getPdf() async {}

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      // maxPageWidth: 1000,
      // useActions: false,
      // canChangePageFormat: true,
      canChangeOrientation: false,
      // pageFormats:pageformat,
      canDebug: false,

      build: (format) => generateDocument(
        format,
      ),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();
    // final image = await imageFromAssetBundle('assets/r2.svg');

    String? _logo = await rootBundle.loadString('assets/img/logo2.svg');

    doc.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: format.copyWith(
            marginBottom: 0,
            marginLeft: 0,
            marginRight: 0,
            marginTop: 0,
          ),
          orientation: pw.PageOrientation.portrait,
          theme: pw.ThemeData.withFont(
            base: font1,
            bold: font2,
          ),
        ),
        build: (context) {
          return pw.Center(
              child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Flexible(
                child: pw.SvgImage(
                  svg: _logo,
                  height: 150,
                ),
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Nama Rs :  ',
                    style: const pw.TextStyle(
                      fontSize: 50,
                    ),
                  ),
                  pw.Text(
                    subject1,
                    style: const pw.TextStyle(
                      fontSize: 50,
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Nama Poli :  ',
                    style: const pw.TextStyle(
                      fontSize: 50,
                    ),
                  ),
                  pw.Text(
                    subject1,
                    style: const pw.TextStyle(
                      fontSize: 50,
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Id Poli :  ',
                    style: const pw.TextStyle(
                      fontSize: 50,
                    ),
                  ),
                  pw.Text(
                    subject1,
                    style: const pw.TextStyle(
                      fontSize: 50,
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'No Ktp :  ',
                    style: const pw.TextStyle(
                      fontSize: 50,
                    ),
                  ),
                  pw.Text(
                    subject1,
                    style: const pw.TextStyle(
                      fontSize: 50,
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'nama : ',
                    style: const pw.TextStyle(
                      fontSize: 50,
                    ),
                  ),
                  pw.Text(
                    name,
                    style: const pw.TextStyle(
                      fontSize: 50,
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'No Hp:  ',
                    style: const pw.TextStyle(
                      fontSize: 50,
                    ),
                  ),
                  pw.Text(
                    subject2,
                    style: const pw.TextStyle(
                      fontSize: 50,
                    ),
                  ),
                ],
              ),
              pw.Divider(),
            ],
          ));
        },
      ),
    );

    return doc.save();
  }
}
