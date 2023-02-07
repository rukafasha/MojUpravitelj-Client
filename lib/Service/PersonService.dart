import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:praksa_frontend/Helper/GlobalUrl.dart';
import 'package:praksa_frontend/Helper/RoleUtil.dart';
import 'package:praksa_frontend/Models/Person.dart';

class PersonService {
  static Future<Person> editPerson(firstNameController, lastNameController,
      userNameController, passwordController, dataController) async {
    var data = RoleUtil.GetData();
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
}
