import 'package:praksa_frontend/ui/background/backgroundTop.dart';
import 'package:praksa_frontend/ui/forms/home_form.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Stack(children: const [
        HomePage(),
        // BackgroundTop(),
      ]),
    );
  }
}
