import 'package:capstone_dicoding_semaapps/pages/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './form_pendaftaran.dart';

class history extends StatelessWidget {
  final String id_poli;
  final String namaPoli;
  final String namaRs;
  final String kodePoli;
  final String name;
  final String nik;
  final String noHp;
  final String noAntri;

  history({
    super.key,
    required this.id_poli,
    required this.namaPoli,
    required this.namaRs,
    required this.kodePoli,
    required this.name,
    required this.nik,
    required this.noHp,
    required this.noAntri,
  });

  final Stream<QuerySnapshot> _report =
      FirebaseFirestore.instance.collection('report').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 37, 213, 131),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => FormPendeftaran(
                        id_poli: '',
                        kodePoli: '',
                        namaPoli: '',
                        namaRs: '',
                      )));
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 26, 198, 106),
        title: Text('History '),
      ),
      body: StreamBuilder(
        stream: _report,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                var test = snapshot.data?.docs.length ?? 0;
                var nomorAntrian = test + 1;
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Reportt(
                          namaRs:
                              snapshot.data!.docChanges[index].doc['Nama_Rs'],
                          NamaPoli:
                              snapshot.data!.docChanges[index].doc['Nama_Poli'],
                          NoHp: snapshot.data!.docChanges[index].doc['No_Hp'],
                          kodePoli: kodePoli,
                          namaPasien: snapshot
                              .data!.docChanges[index].doc['Nama_Pasien'],
                          noAntri: nomorAntrian.toString(),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 3,
                          right: 3,
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          title: Text(
                            snapshot.data!.docChanges[index].doc['Nama_Pasien'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
