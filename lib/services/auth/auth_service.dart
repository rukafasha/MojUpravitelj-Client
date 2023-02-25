import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:praksa_frontend/getFcm.dart';

import '../../helper/global_url.dart';

class AuthService {
  static Future login(TextEditingController _usernameController,
      TextEditingController _passwordController) async {
    String? token = await getFcmToken();
    final personDetails = await http.post(Uri.parse('${GlobalUrl.url}login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': _usernameController.text.toString(),
          'password': _passwordController.text.toString(),
          "deviceID": token.toString()
        }));

    return personDetails;
  }

  static Future userRegistration(
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      TextEditingController usernameController,
      TextEditingController passwordController,
      TextEditingController dateController) async {
    final response = await http.post(Uri.parse('${GlobalUrl.url}registration'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'firstName': firstNameController.text.toString(),
          'lastName': lastNameController.text.toString(),
          'username': usernameController.text.toString(),
          'password': passwordController.text.toString(),
          'dateOfBirth': dateController.text.toString(),
        }));

    return response;
  }

  static Future companyRegistration(
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      TextEditingController usernameController,
      TextEditingController passwordController,
      TextEditingController dateController,
      TextEditingController companyNameController) async {
    final response =
        await http.post(Uri.parse('${GlobalUrl.url}companyRegistration'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'firstName': firstNameController.text.toString(),
              'lastName': lastNameController.text.toString(),
              'username': usernameController.text.toString(),
              'password': passwordController.text.toString(),
              'dateOfBirth': dateController.text.toString(),
              'companyName': companyNameController.text.toString(),
            }));
    return response.statusCode;
  }

  static Future usernameVerification(String username) async {
    final response = await http
        .get(Uri.parse('${GlobalUrl.url}userAccount/username/$username'));

    return response.statusCode;
  }
}
