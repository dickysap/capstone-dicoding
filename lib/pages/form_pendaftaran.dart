import 'package:flutter/material.dart';

class FormPendeftaran extends StatelessWidget {
  final String id_poli;
  final String namaPoli;
  final String namaRs;
  final String kodePoli;
  const FormPendeftaran(
      {super.key,
      required this.id_poli,
      required this.namaPoli,
      required this.namaRs,
      required this.kodePoli});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FORM PENDAFTARAN PASIEN",
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("DATA PASIEN"),
                const SizedBox(height: 20),
                KlinikFormWidget(hintText: namaRs, labelText: "Rumah Sakit"),
                const SizedBox(height: 20),
                KlinikFormWidget(
                    hintText: "${namaPoli} - ${kodePoli}",
                    labelText: "POLIKLINIK"),
                const SizedBox(height: 20),
                InputFormWidget(
                    labelText: "Nama Pasien",
                    hintText: "Masukan nama lengkap pasien"),
                SizedBox(height: 20),
                InputFormWidget(
                    labelText: "No. KTP", hintText: "Masukan Nomor KTP"),
                SizedBox(height: 20),
                InputFormWidget(
                    labelText: "Nomor Handphone",
                    hintText: "Masukan Nomor Handphone yang bisa dihubungi")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputFormWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  const InputFormWidget({
    Key? key,
    required this.labelText,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.pinkAccent),
              gapPadding: 5,
              borderRadius: BorderRadius.circular(20))),
    );
  }
}

class KlinikFormWidget extends StatelessWidget {
  const KlinikFormWidget({
    Key? key,
    required this.hintText,
    required this.labelText,
  }) : super(key: key);

  final String hintText;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: false,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.pinkAccent),
              gapPadding: 5,
              borderRadius: BorderRadius.circular(20))),
    );
  }
}
