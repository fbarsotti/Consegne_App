import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:todo/Page/google_sign_in.dart';
import 'package:todo/Page/home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'To Do',
        theme: ThemeData.light().copyWith(
          colorScheme: const ColorScheme(
            primary: Colors.black,
            primaryVariant: Colors.black,
            secondary: Color(0xFFE0E0E0),
            secondaryVariant: Colors.black,
            surface: Color(0xFFE0E0E0),
            background: Colors.black,
            error: Colors.black,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black,
            onBackground: Colors.black,
            onError: Colors.black,
            brightness: Brightness.dark,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme(
            primary: Colors.grey,
            primaryVariant: Colors.black,
            secondary: ThemeData.dark().colorScheme.surface,
            secondaryVariant: Colors.black,
            surface: ThemeData.dark().colorScheme.surface,
            background: Colors.black,
            error: Colors.black,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.white,
            onBackground: Colors.black,
            onError: Colors.black,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
