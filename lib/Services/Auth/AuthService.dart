import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:praksa_frontend/getFcm.dart';

import '../../Helper/GlobalUrl.dart';

class AuthService {
  static Future login(
      TextEditingController _usernameController, Crypt hashedPwd) async {
    final personDetails = await http.post(Uri.parse('${GlobalUrl.url}login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': _usernameController.text.toString(),
          'password': hashedPwd.toString(),
        }));

    return personDetails;
  }

  static Future userRegistration(
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      TextEditingController usernameController,
      Crypt hashedPwd,
      TextEditingController dateController) async {
    final response = await http.post(Uri.parse('${GlobalUrl.url}registration'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'firstName': firstNameController.text.toString(),
          'lastName': lastNameController.text.toString(),
          'username': usernameController.text.toString(),
          'password': hashedPwd.toString(),
          'dateOfBirth': dateController.text.toString(),
        }));

    return response;
  }

  static Future companyRegistration(
      TextEditingController _firstNameController,
      TextEditingController _lastNameController,
      TextEditingController _usernameController,
      Crypt hashedPwd,
      TextEditingController _dateController,
      TextEditingController _companyNameController) async {
    final response =
        await http.post(Uri.parse('${GlobalUrl.url}companyRegistration'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'firstName': _firstNameController.text.toString(),
              'lastName': _lastNameController.text.toString(),
              'username': _usernameController.text.toString(),
              'password': hashedPwd.toString(),
              'dateOfBirth': _dateController.text.toString(),
              'companyName': _companyNameController.text.toString(),
            }));
    return response.statusCode;
  }

  static Future usernameVerification(String username) async {
    final response = await http
        .get(Uri.parse('${GlobalUrl.url}userAccount/username/$username'));

    return response.statusCode;
  }
}
