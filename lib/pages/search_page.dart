import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController seachtf = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('hospital')
        .where(
          'name',
          isEqualTo: seachtf.text,
        )
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 10,
          ),
          child: TextField(
            controller: seachtf,
            decoration: InputDecoration(
              hintText: 'Search',
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _usersStream,
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
                return Card(
                  child: ListTile(
                    title: Text(
                      snapshot.data!.docChanges[index].doc['name'],
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
