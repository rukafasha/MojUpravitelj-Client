import 'package:flutter/material.dart';
import 'package:praksa_frontend/ui/forms/login_form.dart';

void main() => runApp(const MyApp());

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
