import 'package:capstone_dicoding_semaapps/database/db_helper.dart';
import 'package:capstone_dicoding_semaapps/database/model/cart_model.dart';
import 'package:capstone_dicoding_semaapps/pages/cart_page.dart';
import 'package:capstone_dicoding_semaapps/provider/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListObat extends StatefulWidget {
  static const routeName = '/list-obat';
  final String idRs;
  const ListObat({super.key, required this.idRs});

  @override
  State<ListObat> createState() => _ListObatState();
}

class _ListObatState extends State<ListObat> {
  var users = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OBAT"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookmarksPage(),
                    ));
              },
              icon: Icon(Icons.shopping_cart)),
          SizedBox(width: 20)
        ],
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, value, child) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("obat")
                .where('id_hospital', isEqualTo: widget.idRs)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                var size = MediaQuery.of(context).size;
                final double itemHeight =
                    (size.height - kToolbarHeight - 24) / 2;
                final double itemWidth = size.width / 2;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: (itemWidth / itemHeight),
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        elevation: 1,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.all(10),
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                          image: NetworkImage(snapshot
                                              .data!.docs[index]['img']),
                                          fit: BoxFit.fill),
                                    )),
                                Container(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.docs[index]['nama_obat'],
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                    "Rp. ${snapshot.data!.docs[index]['harga']}"),
                                SizedBox(height: 30),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        value
                                            .addShoppingCart(Cart(
                                                snapshot.data!.docs[index].id,
                                                snapshot.data!.docs[index]
                                                    ['nama_obat'],
                                                snapshot.data!.docs[index]
                                                    ['harga'],
                                                1,
                                                int.parse(snapshot.data!
                                                    .docs[index]['harga']),
                                                users!.uid))
                                            .then((e) {
                                          value.addTotalPrice(double.parse(
                                              snapshot
                                                  .data!.docs[index]['harga']
                                                  .toString()));
                                          final snackBar = SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                                'Product is added to cart'),
                                            duration: Duration(seconds: 1),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }).onError((error, stackTrace) {
                                          print("error" + error.toString());
                                          final snackBar = SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  'Product is already added in cart'),
                                              duration: Duration(seconds: 1));

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        });
                                      },
                                      child: Icon(Icons.shopping_cart)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Text("");
            },
          );
        },
      ),
    );
  }
}
