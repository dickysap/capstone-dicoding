import 'package:capstone_dicoding_semaapps/validator/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile-page';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot<Map<String, dynamic>>> users = firestore
        .collection('users')
        .where("uid", isEqualTo: currentUser.currentUser!.uid)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
          automaticallyImplyLeading: false,
          elevation: 1,
          backgroundColor: Colors.white,
          toolbarHeight: 45,
          shadowColor: Colors.black38,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: users,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        SafeArea(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                        maxRadius: 50,
                                        minRadius: 50,
                                        backgroundColor:
                                            Color.fromARGB(255, 204, 201, 201),
                                        backgroundImage: AssetImage(
                                            'assets/img/doctor.png')),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          "Ubah Foto Profile",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 112, 232, 116),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )),
                                    Divider(
                                      height: 10,
                                      thickness: 1,
                                    ),
                                    Row(
                                      children: const [
                                        Text(
                                          "Info Profile",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.error_outline,
                                          color: Color.fromARGB(
                                              221, 163, 142, 142),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    ProfileEditWidget(
                                        title: "Nama",
                                        onTap: () {},
                                        subtitle: data['nama']),
                                    SizedBox(height: 20),
                                    ProfileEditWidget(
                                        title: "Email",
                                        onTap: () {},
                                        subtitle: data['email']),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                AuthService.signOut();
                                              });
                                            },
                                            child: Text("Logout")))
                                  ],
                                )),
                          ),
                        ))
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ));
  }
}

class ProfileEditWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const ProfileEditWidget({
    Key? key,
    required this.title,
    required this.onTap,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(title),
          const SizedBox(width: 80),
          GestureDetector(
            onTap: onTap,
            child: Flexible(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text(
                        subtitle,
                        overflow: TextOverflow.visible,
                        maxLines: 1,
                      ),
                    ),
                    const Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
