import 'dart:async';

import 'package:capstone_dicoding_semaapps/database/db_helper.dart';
import 'package:capstone_dicoding_semaapps/database/model/cart_model.dart';
import 'package:capstone_dicoding_semaapps/provider/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BookmarksPage extends StatefulWidget {
  static const roteName = '/bookmarks_page';
  static const String bookmarksTitle = 'Bookmarks';
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  DatabaseHelper? dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultStateDatabase.hasData) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.shoppingCart.length,
                    itemBuilder: (context, index) {
                      return CardRestaurant(
                          restaurant: provider.shoppingCart[index]);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("total Price"),
                      Text(provider.getTotalPrice().toString())
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () =>
                            showMyDialog("Berhasil Melakukan Checkout"),
                        child: Text("Check Out")),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Material(
                child: Text("Kamu belum belanja"),
              ),
            );
          }
        },
      ),
    );
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
                    child: LottieBuilder.asset('assets/lottie/success.json')),
                const Text("Sukses"),
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

class CardRestaurant extends StatefulWidget {
  Cart restaurant;
  CardRestaurant({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<CardRestaurant> createState() => _CardRestaurantState();
}

class _CardRestaurantState extends State<CardRestaurant> {
  var users = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    DatabaseHelper dbHelper = DatabaseHelper();

    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isAddToCart(widget.restaurant.id),
          builder: (context, snapshot) {
            return Material(
              child: ListTile(
                enabled: false,
                trailing: Column(
                  children: [
                    // IconButton(
                    //   onPressed: () async {
                    //     await provider.removeCart(widget.restaurant.id);
                    //     await provider.removeTotalPrice(
                    //         double.parse(widget.restaurant.harga));
                    //   },
                    //   icon: const Icon(
                    //     Icons.delete,
                    //     color: Colors.red,
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () async {
                        await provider.removeCart(widget.restaurant.id);
                        await provider.removeTotalPrice(
                            double.parse(widget.restaurant.harga));
                      },
                      onDoubleTap: () => showMyDialog(),
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                title: Text(
                  widget.restaurant.nama,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Rp. ${widget.restaurant.harga}",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onDoubleTap: () => showMyDialog(),
                            onTap: () async {
                              int qty = widget.restaurant.qty;
                              int price = widget.restaurant.initialPrice;
                              qty++;
                              int newPrice = price * qty;
                              await provider
                                  .updateQty(Cart(
                                      widget.restaurant.id,
                                      widget.restaurant.nama,
                                      newPrice.toString(),
                                      qty,
                                      widget.restaurant.initialPrice,
                                      users!.uid))
                                  .then((value) {
                                newPrice = 0;
                                qty = 0;
                                provider.addTotalPrice(double.parse(
                                    widget.restaurant.initialPrice.toString()));
                              });
                            },
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Colors.black,
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            widget.restaurant.qty.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        GestureDetector(
                            onDoubleTap: () => showMyDialog(),
                            onTap: () async {
                              int qty = widget.restaurant.qty;
                              int price = widget.restaurant.initialPrice;
                              qty--;
                              int newPrice = price * qty;
                              if (qty > 0) {
                                await provider
                                    .updateQty(Cart(
                                        widget.restaurant.id,
                                        widget.restaurant.nama,
                                        newPrice.toString(),
                                        qty,
                                        widget.restaurant.initialPrice,
                                        users!.uid))
                                    .then((value) {
                                  newPrice = 0;
                                  qty = 0;
                                  provider.removeTotalPrice(double.parse(widget
                                      .restaurant.initialPrice
                                      .toString()));
                                }).then((value) => Duration(milliseconds: 300));
                              }
                            },
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: Colors.black,
                            )),
                      ],
                    )
                  ],
                ),
                onTap: () {},
              ),
            );
          },
        );
      },
    );
  }

  Future<void> showMyDialog() async => showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text("Pelan - pelan lah"),
            ),
            content: Text("Buru - buru bat kek ngambil gaji"),
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
