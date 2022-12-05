import 'dart:math';

import 'package:capstone_dicoding_semaapps/pages/form_pendaftaran.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListPoli extends StatelessWidget {
  final String title;
  static const routeName = '/daftar-berobat';
  const ListPoli({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    List colors = [
      Colors.red.shade100,
      Colors.red.shade200,
      Colors.pink.shade100,
      Colors.pink.shade200,
      Colors.purple.shade100,
      Colors.purple.shade200
    ];
    Random random = new Random();
    int idx = 0;
    final Stream<QuerySnapshot> _poli =
        FirebaseFirestore.instance.collection('poli').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _poli,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went Wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "POLIKLINK",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text("")
                    ],
                  )),
              Expanded(
                child: GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FormPendeftaran(
                                  kodePoli: snapshot.data!.docs[index]['kode'],
                                  id_poli: snapshot.data!.docs[index].id,
                                  namaPoli: snapshot.data!.docs[index]['nama'],
                                  namaRs: title)),
                        );
                      },
                      child: Container(
                          margin: EdgeInsets.all(10),
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              color: colors[Random().nextInt(colors.length)],
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  height: 50,
                                  child: Image.asset(
                                    'assets/img/stethoscope_1.png',
                                  )),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                width: 80,
                                child: Text(
                                  snapshot.data!.docs[index]['nama'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey.shade800),
                                  // overflow: TextOverflow.fade,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          )),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
