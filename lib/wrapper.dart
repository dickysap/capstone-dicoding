import 'package:capstone_dicoding_semaapps/login/login_page.dart';
import 'package:capstone_dicoding_semaapps/pages/home_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  static const routeName = '/wrapper';
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return (user == null) ? const LoginPage() : const HomePage();
  }
}
