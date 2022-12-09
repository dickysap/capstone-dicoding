import 'package:capstone_dicoding_semaapps/pages/bottom_nav.dart';
import 'package:capstone_dicoding_semaapps/pages/home_page.dart';
import 'package:capstone_dicoding_semaapps/pages/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReportPage extends StatelessWidget {
  final String namaRs;
  final String namaPoli;
  final String noHp;
  final String kodePoli;
  final String namaPasien;
  final String noAntri;
  const ReportPage(
      {super.key,
      required this.namaRs,
      required this.namaPoli,
      required this.noHp,
      required this.kodePoli,
      required this.namaPasien,
      required this.noAntri});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()));
            },
            icon: Icon(Icons.arrow_back)),
        title: Text("Print to Pdf"),
      ),
      body: SafeArea(
        child: Reportt(
            namaRs: namaRs,
            NamaPoli: namaPoli,
            NoHp: noHp,
            kodePoli: kodePoli,
            namaPasien: namaPasien,
            noAntri: noAntri),
      ),
    );
  }
}
