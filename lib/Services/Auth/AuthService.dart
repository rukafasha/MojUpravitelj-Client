import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Helper/GlobalUrl.dart';

class AuthService {
  static Future login(TextEditingController _usernameController,
      TextEditingController _passwordController) async {
    final personDetails = await http.post(Uri.parse('${GlobalUrl.url}login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': _usernameController.text.toString(),
          'password': _passwordController.text.toString(),
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
      TextEditingController _firstNameController,
      TextEditingController _lastNameController,
      TextEditingController _usernameController,
      TextEditingController _passwordController,
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
              'password': _passwordController.text.toString(),
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
