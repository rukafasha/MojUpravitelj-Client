import 'dart:convert';

import '../Helper/GlobalUrl.dart';
import '../Models/Person.dart';
import 'package:http/http.dart' as http;

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
}
