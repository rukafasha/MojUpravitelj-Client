import 'dart:convert';

import '../Helper/GlobalUrl.dart';
import '../Helper/RoleUtil.dart';
import '../Models/Building.dart';
import 'package:http/http.dart' as http;

class BuildingService {
  static var data;

  BuildingService(readData) {
    data = readData;
  }

  Future<List<Building>> fetchBuildings() async {
    final http.Response response;

    var url =
        Uri.parse('${GlobalUrl.url}building/get/company/${data["companyId"]}');
    response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((building) => Building.fromMap(building))
          .toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }
}
