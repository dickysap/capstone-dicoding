import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Reportt extends StatelessWidget {
  String namaRs;
  String NamaPoli;
  String NoHp;
  String kodePoli;
  String namaPasien;
  String noAntri;

  Reportt(
      {super.key,
      required this.namaRs,
      required this.NamaPoli,
      required this.NoHp,
      required this.kodePoli,
      required this.namaPasien,
      required this.noAntri});
  final pdf = pw.Document();

  void initState() {
    namaRs = namaRs;
    NamaPoli = NamaPoli;
    NoHp = NoHp;
    kodePoli = kodePoli;
    namaPasien = namaPasien;
    noAntri = noAntri;
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
    print(namaRs);
    print(NamaPoli);
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
                    namaRs,
                    style: const pw.TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    NamaPoli,
                    style: const pw.TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    kodePoli,
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
                    noAntri,
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
                    namaPasien,
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
                    NoHp,
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
