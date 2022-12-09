import 'package:capstone_dicoding_semaapps/database/db_helper.dart';
import 'package:capstone_dicoding_semaapps/database/model/cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ResultStateDatabase { noData, hasData, loading, error }

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;
  final String idUsers;
  DatabaseProvider(this.idUsers, {required this.databaseHelper}) {
    _getShoppingCart();
  }
  double _totalPrice = 0.0;
  double get totalprice => _totalPrice;

  ResultStateDatabase? _state;
  ResultStateDatabase? get state => _state;

  String _message = '';
  String get message => _message;

  List<Cart> _cart = [];
  List<Cart> get shoppingCart => _cart;

  void _getShoppingCart() async {
    _cart = await databaseHelper.getCart(idUsers);
    print(_cart);

    if (_cart.isNotEmpty) {
      _state = ResultStateDatabase.hasData;
      notifyListeners();
    } else {
      _state = ResultStateDatabase.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  Future addShoppingCart(Cart cart) async {
    try {
      await databaseHelper.insertCart(cart);
      _getShoppingCart();
    } catch (e) {
      _state = ResultStateDatabase.error;
      _message = 'Error $e';
    }
  }

  Future updateQty(Cart cart) async {
    try {
      await databaseHelper.updateQuantity(cart);
      _getShoppingCart();
    } catch (e) {
      _state = ResultStateDatabase.error;
      _message = "Error $e";
    }
  }

  Future<bool> isAddToCart(String id) async {
    final readyAtCart = await databaseHelper.getCartById(id);
    return readyAtCart.isNotEmpty;
  }

  Future removeCart(String id) async {
    try {
      await databaseHelper.removeCart(id);
      _getShoppingCart();
    } catch (e) {
      _state = ResultStateDatabase.error;
      _message = 'Error $e';
      notifyListeners();
    }
  }

  void _setPrefItem() async {
    const cartItem = 'cart-item';
    const total = 'total-price';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(total, _totalPrice);
    print("Hasil di setPref - $_totalPrice");
    notifyListeners();
  }

  void _getPrefItem() async {
    const cartItem = 'cart-item';
    const total = 'total-price';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _totalPrice = prefs.getDouble(total) ?? 0.0;
    notifyListeners();
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefItem();
    notifyListeners();
  }

  Future removeTotalPrice(double productPrice) async {
    _totalPrice = _totalPrice - productPrice;
    _setPrefItem();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefItem();
    return _totalPrice;
  }
}
