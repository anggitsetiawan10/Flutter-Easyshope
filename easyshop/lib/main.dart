import 'package:flutter/material.dart';
import 'launcher.dart';
import 'users/landingpage.dart' as users;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LauncherPage(),
      routes: <String, WidgetBuilder>{
        '/keranjanguser': (BuildContext context) => users.LandingPage(nav: '2'),
      },
    );
  }
}



// import 'package:flutter/material.dart';
// import 'launcher.dart';
// import 'users/landingpage.dart' as users;
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const LauncherPage(),
//       routes: <String, WidgetBuilder>{
//         '/keranjanguser': (BuildContext context) => new users.LandingPage(nav:'2'),
//       },
//     );
//   }
// }
