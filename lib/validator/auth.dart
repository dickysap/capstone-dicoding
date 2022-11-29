import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static Future<void> signOut() async {
    auth.signOut();
  }

  // static Future<Object> signUp(String email, String password) async {
  //   try {
  //     User? user = (await auth.createUserWithEmailAndPassword(
  //             email: email, password: password))
  //         .user;
  //     print("ID USER - " + user!.uid);
  //     return AlertDialog(
  //       title: Text('Success'),
  //     );
  //   } catch (e) {
  //     print(e);
  //     return e.toString();
  //   }
  // }

  // static Future<String> signIn(String email, String password) async {
  //   try {
  //     User? user = (await auth.signInWithEmailAndPassword(
  //             email: email, password: password))
  //         .user;
  //     print(user!.uid);
  //     return 'Success';
  //   } catch (e) {
  //     print(e);
  //     return e.toString();
  //   }
  // }

  static Future<User?> signUp(String email, String password) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<User?> signIn(String email, String password) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      print("Hasil dari resul.user - ${result.user}");
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }

  static Stream<User?> get firebaseUserStream => auth.authStateChanges();
}
