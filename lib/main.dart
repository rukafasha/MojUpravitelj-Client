import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:praksa_frontend/ui/forms/login_form.dart';

void main() async {
  await Hive.initFlutter();

  var box = await Hive.openBox("mybox");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Moj upravitelj',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Stack(
          children: const [
            LoginForm(),
          ],
        )));
  }
}
