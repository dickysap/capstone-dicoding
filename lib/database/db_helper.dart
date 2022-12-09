import 'package:capstone_dicoding_semaapps/database/model/cart_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblShoppingCart = 'shopping_cart';

  Future<Database> _initilizaeDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase('$path/restaurant.db', onCreate: (db, version) async {
      await db.execute(''' CREATE TABLE $_tblShoppingCart(
          idUsers TEXT,
           id TEXT, 
           nama TEXT, 
           harga TEXT, 
           initialPrice INTEGER,
           qty INTEGER
          )''');
    }, version: 1);
    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initilizaeDB();
    return _database;
  }

  Future<void> insertCart(Cart cart) async {
    final db = await database;
    await db!.insert(_tblShoppingCart, cart.toMap());
  }

  Future<List<Cart>> getCart(String idUsers) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!
        .query(_tblShoppingCart, where: 'idUsers = ?', whereArgs: [idUsers]);
    return results.map((e) => Cart.fromMap(e)).toList();
  }

  Future<Map> getCartById(String id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(_tblShoppingCart, where: 'id = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeCart(String id) async {
    final db = await database;

    await db!.delete(_tblShoppingCart, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await database;
    print("hasil cart database -  $cart");
    return await dbClient!.update(_tblShoppingCart, cart.toMap(),
        where: "id = ?", whereArgs: [cart.id]);
  }
}
