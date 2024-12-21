import 'dart:async';
import 'package:flutter/material.dart';
import 'users/landingpage.dart'; // Impor sesuai nama file
import 'constans.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({super.key});
  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    super.initState();
    starLaunching();
  }

  starLaunching() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => const LandingPage()), // Gunakan LandingPage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Palette.white, Palette.menuMart],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                "assets/LOGO 1 COLOR.png",
                height: 90.0,
                width: 270.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
