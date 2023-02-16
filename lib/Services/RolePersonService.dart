import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Helper/GlobalUrl.dart';

class RolePersonService {
  static Future<void> AddRepresentativeRole(int personId, int roleId)async{
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}rolePerson/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "personId": personId,
        "roleId": roleId
      }),
    );
  }
}
