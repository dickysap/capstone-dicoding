import 'package:flutter/material.dart';

class FormPendeftaran extends StatelessWidget {
  final String id_poli;
  final String namaPoli;
  final String namaRs;
  const FormPendeftaran(
      {super.key,
      required this.id_poli,
      required this.namaPoli,
      required this.namaRs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Text(id_poli), Text(namaPoli), Text(namaRs)],
      ),
    );
  }
}
