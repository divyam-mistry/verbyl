import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:flutter/material.dart';
import 'package:verbyl_project/authentication/login_phone.dart';
import '/theme.dart';
import 'authentication/login_email.dart';
import 'pages/home.dart';

String magicAuthCredentials = "pk_live_B8336C86A7989E33";

void main() {
  runApp(const MyApp());
  Magic.instance = Magic(magicAuthCredentials);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      title: 'Verbyl',
      home: Stack(
        children: [
          const LoginEmail(),
          Magic.instance.relayer,
        ],
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final List<Color> colors = [
    Colors.lightBlue,
    textLight,
    Colors.blue.shade700,
    textLight,
    Colors.lightBlue
  ];

  final List<int> duration = [900, 700, 600, 800, 500];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgDark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 0.2 * size.height,
            child: Image.asset("assets/images/logo.png"),
          ),
          SizedBox(
            height: size.height * 0.1,
            width: size.width * 0.75,
            child: null,
            // child: MusicVisualizer(
            //   barCount: 15,
            //   colors: colors,
            //   duration: duration,
            // ),
          ),
        ],
      ),
    );
  }
}


