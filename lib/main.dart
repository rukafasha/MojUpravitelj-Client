import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:praksa_frontend/ui/firebase_options.dart';
import 'package:praksa_frontend/ui/forms/login_form.dart';

import '../../for_ground_local_notification.dart';
import '../../ui/firebase_options.dart';
import '../../ui/forms/login_form.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();

  var box = await Hive.openBox("mybox");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalNotification.initialize();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.showNotification(message);
    });
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
