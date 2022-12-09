import 'package:capstone_dicoding_semaapps/pages/report.dart';
import 'package:capstone_dicoding_semaapps/pages/report_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './form_pendaftaran.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var users = FirebaseAuth.instance.currentUser;
    final Stream<QuerySnapshot> _report = FirebaseFirestore.instance
        .collection('report')
        .where('id_users', isEqualTo: users!.uid)
        .snapshots();
    return Scaffold(
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
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReportPage(
                          namaRs:
                              snapshot.data!.docChanges[index].doc['nama_Rs'],
                          namaPoli:
                              snapshot.data!.docChanges[index].doc['nama_Poli'],
                          noHp: snapshot.data!.docChanges[index].doc['no_Hp'],
                          kodePoli: snapshot.data!.docs[index]['kodePoli'],
                          namaPasien: snapshot
                              .data!.docChanges[index].doc['nama_Pasien'],
                          noAntri: snapshot.data!.docs[index]['noAntrian']
                              .toString(),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      elevation: 3,
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                left: 3,
                                right: 3,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Text(
                                        "${snapshot.data!.docs[index]['nama_Rs']}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        snapshot.data!.docs[index]
                                            ['nama_Pasien'],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Antrian ke - ${snapshot.data!.docs[index]['noAntrian']}",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(height: 20),
                                      Text("Status - Masih Dalam Antrian")
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
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
