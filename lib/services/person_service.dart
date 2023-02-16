import 'dart:convert';

import '../helper/global_url.dart';
import '../models/person.dart';
import 'package:http/http.dart' as http;
import 'package:praksa_frontend/helper/role_util.dart';

class PersonService {
  static Future<Person> fetchUserById(int id) async {
    var url = Uri.parse('${GlobalUrl.url}person/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Person.fromMap(json.decode(response.body));
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  static Future<Person> editPerson(firstNameController, lastNameController,
      userNameController, passwordController, dataController) async {
    var data = RoleUtil.getData();
    var id = data["personId"];

    final response = await http.put(
      Uri.parse('${GlobalUrl.url}person/edit/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'personId': id,
        'firstName': firstNameController,
        'lastName': lastNameController,
        'dateOfBirth': dataController.toString(),
        'isActive': true,
        'companyId': data["companyId"],
        'userAccountId': 1,
      }),
    );

    if (response.statusCode == 201) {
      return Person.fromJson(response.body);
    } else {
      throw Exception('Person update failed!');
    }
  }

  static dynamic getData(firstNameController, lastNameController,
      usernameController, passwordController, dataController) {
    var data = {
      'firstName': firstNameController,
      'lastName': lastNameController,
      'DOB': dataController,
      'username': usernameController,
      'password': passwordController
    };
    return data;
  }
}