import 'package:capstone_dicoding_semaapps/login/login_page.dart';
import 'package:capstone_dicoding_semaapps/validator/auth.dart';
import 'package:capstone_dicoding_semaapps/validator/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController(text: "");
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController namaController = TextEditingController(text: "");
  TextEditingController usernameController = TextEditingController(text: "");
  TextEditingController roleController = TextEditingController();
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
                    controller: emailController,
                    decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.mail),
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
                    // validator: Validator.emailValidate,
                    controller: usernameController,
                    decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.person),
                        hintText: 'username',
                        labelText: 'username',
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.pinkAccent),
                            gapPadding: 5,
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    // validator: Validator.emailValidate,
                    controller: namaController,
                    decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.person),
                        hintText: 'fulan',
                        labelText: 'nama',
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.pinkAccent),
                            gapPadding: 5,
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    // validator: Validator.emailValidate,
                    controller: roleController,
                    decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.person),
                        // hintText: 'example@gmail.com',
                        labelText: 'Role',
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
                          icon: Icon(!_obsecure
                              ? Icons.visibility
                              : Icons.visibility_off),
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
                        var username = '@${usernameController.text}';
                        if (_key.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text)
                                .then((value) =>
                                    AuthService.signOut().then((value) async {
                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(user!.uid)
                                          .set({
                                        'uid': user.uid,
                                        'email': emailController.text,
                                        'password': passwordController.text,
                                        'nama': namaController.text,
                                        'username': username,
                                        'bio': "",
                                        'handphone': "",
                                        'kelamin': "",
                                        'profile_img': "",
                                        'role': roleController.text
                                      });
                                    }))
                                .then((value) => AuthService.signOut())
                                .then((value) => showMyDialog(
                                    "",
                                    "assets/lottie/success.json",
                                    "Register Success"))
                                .then((value) {
                              emailController.clear();
                              passwordController.clear();
                              usernameController.clear();
                              namaController.clear();
                              roleController.clear();
                            });
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              showMyDialog(
                                  "Password Lemah",
                                  "assets/lottie/error.json",
                                  "Register Failed");
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              showMyDialog(
                                  "Email sudah tedaftar",
                                  "assets/lottie/error.json",
                                  "Register Failder");
                              print(
                                  'The account already exists for that email.');
                            }
                          }
                        }
                      },
                      child: const Text(
                        "Register",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('have Account ?'),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginPage.routeName);
                          },
                          child: const Text('Login Here'))
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

  Future<void> showMyDialog(
          String subtitle, String lottie, String status) async =>
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Column(
              children: [
                SizedBox(height: 100, child: LottieBuilder.asset(lottie)),
                Text(status),
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
