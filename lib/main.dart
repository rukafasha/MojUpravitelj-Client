import 'package:flutter/material.dart';
import 'package:praksa_frontend/ui/background/background.dart';
import 'package:praksa_frontend/ui/forms/login_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
            body: Stack(
          children: [
            Background(),
            const LoginForm(),
          ],
        )));
  }
}
