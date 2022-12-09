import 'package:capstone_dicoding_semaapps/pages/history_page.dart';
import 'package:capstone_dicoding_semaapps/pages/home_page.dart';
import 'package:capstone_dicoding_semaapps/pages/report.dart';
import 'package:capstone_dicoding_semaapps/validator/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FormPendeftaran extends StatefulWidget {
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

  @override
  State<FormPendeftaran> createState() => _FormPendeftaranState();
}

class _FormPendeftaranState extends State<FormPendeftaran> {
  TextEditingController name = TextEditingController(text: "");

  TextEditingController nik = TextEditingController(text: "");

  TextEditingController noHp = TextEditingController(text: "");

  CollectionReference ref = FirebaseFirestore.instance.collection('report');

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GlobalKey<FormState> _key = GlobalKey<FormState>();
    var antrian = FirebaseFirestore.instance
        .collection('report')
        .where('id_poli', isEqualTo: widget.id_poli)
        .get();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "FORM PENDAFTARAN PASIEN",
            style: TextStyle(fontSize: 15),
          ),
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
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          const Text("DATA PASIEN"),
                          const SizedBox(height: 20),
                          Text(snapshot.data!.docs.length.toString()),
                          KlinikFormWidget(
                              hintText: widget.namaRs,
                              labelText: "Rumah Sakit"),
                          const SizedBox(height: 20),
                          KlinikFormWidget(
                              hintText:
                                  "${widget.namaPoli} - ${widget.kodePoli}",
                              labelText: "POLIKLINIK"),
                          const SizedBox(height: 20),
                          TextFormField(
                            validator: Validator.formKsosng,
                            controller: name,
                            decoration: InputDecoration(
                              hintText: 'Nama Pasien',
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            validator: Validator.formKsosng,
                            controller: nik,
                            maxLines: null,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Nik',
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            validator: Validator.formKsosng,
                            controller: noHp,
                            maxLines: null,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'No Hp',
                            ),
                          ),
                          SizedBox(height: 20),
                          MaterialButton(
                              color: Color.fromARGB(255, 109, 158, 231),
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  try {
                                    ref.add({
                                      'id_users': auth.currentUser!.uid,
                                      'Nama_Pasien': name.text,
                                      'Nama_Rs': widget.namaRs,
                                      'Nama_Poli': widget.namaPoli,
                                      'id_poli': widget.id_poli,
                                      'No_Ktp': nik.text,
                                      'No_Hp': noHp.text,
                                      'noAntrian': nomorAntrian,
                                    }).whenComplete(() {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => Reportt(
                                              namaRs: widget.namaRs,
                                              NamaPoli: widget.namaPoli,
                                              NoHp: noHp.text,
                                              kodePoli: widget.kodePoli,
                                              namaPasien: name.text,
                                              noAntri: nomorAntrian.toString(),
                                            ),
                                          ));
                                    });
                                  } catch (e) {
                                    showMyDialog("Data ada yang kosong");
                                  }
                                }
                              },
                              child: Text("Cetak"))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return Text("data");
          },
        ));
  }

  Future<void> showMyDialog(String subtitle) async => showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Column(
              children: [
                SizedBox(
                    height: 100,
                    child: LottieBuilder.asset('assets/lottie/error.json')),
                const Text("Login Failed"),
                const SizedBox(height: 10)
              ],
            )),
            content: Text(
              subtitle,
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                child: const Center(child: Text('Ok')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
