import 'dart:convert';

import '../Helper/GlobalUrl.dart';
import 'package:http/http.dart' as http;

import '../Models/Role.dart';


class RoleService {
  static Future<int> GetByString(String desc) async {
    final http.Response response;

    var url =
        Uri.parse('${GlobalUrl.url}role/get/name/$desc');
    response = await http.get(url);

    if (response.statusCode == 200) {
      var role = Role.fromJson(response.body);
      return role.roleId;
    } else {
      throw Exception('Unexpected error occured');
    }
  }
}
