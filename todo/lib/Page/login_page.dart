import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo/Page/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Title"),
          const Text("Description"),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.black,
              minimumSize: const Size(double.infinity, 50),
            ),
            icon: const FaIcon(
              FontAwesomeIcons.google,
              color: Colors.black,
            ),
            label: const Text("Sign in with google"),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            },
          ),
        ],
      ),
    );
  }
}
