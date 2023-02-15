import 'dart:convert';

import '../Helper/GlobalUrl.dart';
import '../Models/AppartmentPerson.dart';
import 'package:http/http.dart' as http;

class AppartmentPersonService {
  // ignore: prefer_typing_uninitialized_variables
  static var data;

  AppartmentPersonService(readData) {
    data = readData;
  }

  Future<List<AppartmentPerson>> fetchAppartmentsByPerson() async {
    final http.Response response;

    var url = Uri.parse(
        '${GlobalUrl.url}appartmentPerson/person/${data["personId"]}');
    response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((appartment) => AppartmentPerson.fromMap(appartment))
          .toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }
}
