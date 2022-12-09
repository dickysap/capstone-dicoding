import 'package:capstone_dicoding_semaapps/database/db_helper.dart';
import 'package:capstone_dicoding_semaapps/login/login_page.dart';
import 'package:capstone_dicoding_semaapps/pages/list_obat.dart';
import 'package:capstone_dicoding_semaapps/pages/list_poli.dart';
import 'package:capstone_dicoding_semaapps/pages/detail_rumah_sakit.dart';
import 'package:capstone_dicoding_semaapps/pages/home_page.dart';
import 'package:capstone_dicoding_semaapps/pages/search_page.dart';
import 'package:capstone_dicoding_semaapps/provider/cart_provider.dart';
import 'package:capstone_dicoding_semaapps/register/register_page.dart';
import 'package:capstone_dicoding_semaapps/validator/auth.dart';
import 'package:capstone_dicoding_semaapps/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var users = FirebaseAuth.instance.currentUser;

    return ChangeNotifierProvider(
      create: (context) =>
          DatabaseProvider(databaseHelper: DatabaseHelper(), users!.uid),
      child: StreamProvider.value(
        value: AuthService.firebaseUserStream,
        initialData: null,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SEMA - SEHAT BERSAMA',
          initialRoute: Wrapper.routeName,
          routes: {
            ListObat.routeName: (context) => ListObat(
                idRs: ModalRoute.of(context)?.settings.arguments as String),
            Wrapper.routeName: (context) => const Wrapper(),
            HomePage.routeName: (context) => const HomePage(),
            LoginPage.routeName: (context) => const LoginPage(),
            RegisterPage.routeName: (context) => const RegisterPage(),
            SearchPage.routeName: (context) => const SearchPage(),
            ListPoli.routeName: (context) => ListPoli(
                title: ModalRoute.of(context)?.settings.arguments as String)
          },
        ),
      ),
    );
  }
}
