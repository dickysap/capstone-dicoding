import 'package:flutter/cupertino.dart';

class Cart {
  final String idUsers;
  final String id;
  final String nama;
  final String harga;
  final int initialPrice;
  final int qty;

  Cart(this.id, this.nama, this.harga, this.qty, this.initialPrice,
      this.idUsers);

  Cart.fromMap(Map<String, dynamic> data)
      : idUsers = data['idUsers'],
        id = data['id'],
        nama = data['nama'] ?? "",
        harga = data['harga'],
        initialPrice = data['initialPrice'],
        qty = data['qty'];

  Map<String, dynamic> toMap() {
    return {
      'idUsers': idUsers,
      'id': id,
      'nama': nama,
      'harga': harga,
      'initialPrice': initialPrice,
      'qty': qty
    };
  }
}
