import 'package:capstone_dicoding_semaapps/login/login_page.dart';
import 'package:capstone_dicoding_semaapps/pages/home_page.dart';

import 'package:capstone_dicoding_semaapps/pages/search_page.dart';
import 'package:capstone_dicoding_semaapps/register/register_page.dart';
import 'package:capstone_dicoding_semaapps/validator/auth.dart';
import 'package:capstone_dicoding_semaapps/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //     options: FirebaseOptions(
      //   apiKey: "AIzaSyCRIcjTBgS1bNZoAUbO-8AW0WHiaM8k2iU",
      //   projectId: "dicoding-capstone",
      //   messagingSenderId: "71438229205",
      //   appId: "1:71438229205:web:a1d5510824a04a5fe7cc5c",
      // )
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService.firebaseUserStream,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SEMA - SEHAT BERSAMA',
        initialRoute: Wrapper.routeName,
        routes: {
          Wrapper.routeName: (context) => const Wrapper(),
          HomePage.routeName: (context) => const HomePage(),
          LoginPage.routeName: (context) => const LoginPage(),
          RegisterPage.routeName: (context) => const RegisterPage(),
          SearchPage.routeName: (context) => const SearchPage(),
          SearchPage.routeName: (context) => const SearchPage(),
        },
      ),
    );
  }
}
