import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getFcmToken() async {
  if(kIsWeb){
    return null;
  }
  if (Platform.isIOS) {
    String? fcmKey = await FirebaseMessaging.instance.getToken();
    return fcmKey;
  }
  if(Platform.isWindows){
    return null;
  }
  String? fcmKey = await FirebaseMessaging.instance.getToken();
  return fcmKey;
}
