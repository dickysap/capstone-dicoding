import 'package:capstone_dicoding_semaapps/pages/detail_rumah_sakit.dart';
import 'package:capstone_dicoding_semaapps/pages/history_page.dart';
import 'package:capstone_dicoding_semaapps/pages/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home-page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _hospital =
      FirebaseFirestore.instance.collection('hospital').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 174, 228, 176),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "S E M A",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Sehat Bersama",
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchPage.routeName);
              },
              icon: const Icon(Icons.search),
            ),
          ]),
      body: StreamBuilder<QuerySnapshot>(
        stream: _hospital,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went Wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListCard(
                data: data,
                id: document.id,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class ListCard extends StatelessWidget {
  const ListCard({
    Key? key,
    required this.data,
    required this.id,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailRumahSakit(namaRS: data['name'], idRS: id),
                ));
          },
          leading: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                    image: NetworkImage(data['img']), fit: BoxFit.cover)),
          ),
          title: Text(data['name']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data['location']),
              const SizedBox(height: 10),
              Text(data['telepon']),
            ],
          ),
        ),
      ),
    );
  }
}
