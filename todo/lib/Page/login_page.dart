import 'package:flutter/material.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RedHatDisplay',
                  height: 0.8,
                ),
                children: [
                  TextSpan(text: 'Hello There'),
                  TextSpan(
                    text: '.',
                    style: TextStyle(
                      color: Color(0xff4285F4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff4285F4),
                onPrimary: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
              icon: const FaIcon(
                FontAwesomeIcons.google,
                color: Colors.white,
              ),
              label: const Text(
                'Sign in with Google',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'RedHatDisplay',
                ),
              ),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                elevation: 0,
                side: const BorderSide(
                  width: 1.5,
                  color: Colors.black,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
              icon: const FaIcon(
                FontAwesomeIcons.facebook,
                color: Colors.black,
              ),
              label: const Text(
                'Sign in with FaceBook',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'RedHatDisplay',
                ),
              ),
              onPressed: () {},
            ),
            Expanded(
              child: Container(),
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'RedHatDisplay',
                  height: 0.8,
                ),
                children: [
                  TextSpan(text: 'By '),
                  TextSpan(
                    text: 'Marchesini&Zardin',
                    style: TextStyle(
                      color: Color(0xff4285F4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
