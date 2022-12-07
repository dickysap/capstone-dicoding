import 'package:capstone_dicoding_semaapps/pages/home_page.dart';
import 'package:capstone_dicoding_semaapps/pages/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FormPendeftaran extends StatelessWidget {
  final String id_poli;
  final String namaPoli;
  final String namaRs;
  final String kodePoli;

  FormPendeftaran(
      {super.key,
      required this.id_poli,
      required this.namaPoli,
      required this.namaRs,
      required this.kodePoli});

  TextEditingController name = TextEditingController(text: "");
  TextEditingController nik = TextEditingController(text: "");
  TextEditingController noHp = TextEditingController(text: "");

  CollectionReference ref = FirebaseFirestore.instance.collection('report');
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var antrian = FirebaseFirestore.instance
        .collection('report')
        .where('id_users', isEqualTo: auth.currentUser!.uid)
        .where('id_poli', isEqualTo: id_poli)
        .get();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "FORM PENDAFTARAN PASIEN",
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            MaterialButton(
              onPressed: () {},
              child: Text(
                "save",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 251, 251, 251),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomePage()));
              },
              child: Text(
                "Back",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 251, 251, 251),
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: antrian,
          builder: (context, snapshot) {
            var test = snapshot.data?.docs.length ?? 0;
            var nomorAntrian = test + 1;

            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text("DATA PASIEN"),
                        const SizedBox(height: 20),
                        Text(snapshot.data!.docs.length.toString()),
                        KlinikFormWidget(
                            hintText: namaRs, labelText: "Rumah Sakit"),
                        const SizedBox(height: 20),
                        KlinikFormWidget(
                            hintText: "${namaPoli} - ${kodePoli}",
                            labelText: "POLIKLINIK"),
                        const SizedBox(height: 20),
                        TextField(
                          controller: name,
                          decoration: InputDecoration(
                            hintText: 'Nama Pasien',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: nik,
                          maxLines: null,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Nik',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: noHp,
                          maxLines: null,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'No Hp',
                          ),
                        ),
                        SizedBox(height: 20),
                        MaterialButton(
                            color: Color.fromARGB(255, 99, 109, 226),
                            onPressed: () {
                              ref.add({
                                'id_users': auth.currentUser!.uid,
                                'Nama_Pasien': name.text,
                                'Nama_Rs': namaRs,
                                'Nama_Poli': namaPoli,
                                'id_poli': id_poli,
                                'No_Ktp': nik.text,
                                'No_Hp': noHp.text,
                              }).whenComplete(() {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Reportt(
                                        namaRs: namaRs,
                                        NamaPoli: namaPoli,
                                        NoHp: noHp.text,
                                        kodePoli: kodePoli,
                                        namaPasien: name.text,
                                        noAntri: nomorAntrian.toString(),
                                      ),
                                    ));
                              });
                            },
                            child: Text("submit"))
                      ],
                    ),
                  ),
                ),
              );
            }
            return Text("data");
          },
        ));
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
