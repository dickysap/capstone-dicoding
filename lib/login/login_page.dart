import 'package:capstone_dicoding_semaapps/register/register_page.dart';
import 'package:capstone_dicoding_semaapps/validator/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController(text: "");
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController(text: "");
  bool _obsecure = true;
  void _toggle() {
    setState(() {
      _obsecure = !_obsecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  SafeArea(
                      child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 150,
                          child: Lottie.asset('assets/lottie/login.json'))),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: Validator.emailValidate,
                    controller: usernameController,
                    decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.person),
                        hintText: 'example@gmail.com',
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.pinkAccent),
                            gapPadding: 5,
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: Validator.passwordValidate,
                    controller: passwordController,
                    obscureText: _obsecure,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: _toggle,
                          icon: Icon(_obsecure
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        hintText: 'min 8 character',
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.pinkAccent),
                            gapPadding: 5,
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton(
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: usernameController.text,
                                    password: passwordController.text);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              showMyDialog('Username / Email tidak di temukan');
                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              showMyDialog('Password salah');
                            }
                          }
                        }
                      },
                      child: const Text(
                        "Login",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Dont have Account ?'),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RegisterPage.routeName);
                          },
                          child: const Text('Register Now'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
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
                    child: LottieBuilder.asset('assets/lottie/error.json')),
                const Text("Login Failed"),
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
