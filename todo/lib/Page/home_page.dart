import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/Page/show_element.dart';
import 'package:todo/Page/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Something Went Wrong!"));
        } else if (snapshot.hasData) {
          final user = FirebaseAuth.instance.currentUser;
          CollectionReference collectionReference =
              FirebaseFirestore.instance.collection('users');

          Map<String, dynamic> collection = {"email": "${user!.email}"};

          collectionReference.snapshots().listen((snapshot) {
            List temp = [];
            List onlyEmailList = [];

            for (int i = 0; i < snapshot.docs.length; i++) {
              temp.add(snapshot.docs[i].data().toString());
            }

            for (int i = 0; i < temp.length; i++) {
              String tempString = temp[i].toString().trim();
              List temporaryList = tempString.split(": ");
              onlyEmailList.add(temporaryList[1]
                  .toString()
                  .substring(0, temporaryList[1].toString().length - 1));
            }

            if (!onlyEmailList.contains("${user.email}")) {
              collectionReference.add(collection);
            }
          });

          return const ShowElementPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
