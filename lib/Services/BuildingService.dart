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

  Future<int> AddBuilding(addressController, numbOfAppController) async {
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}building/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'address': addressController.toString(),
        'companyId': data["companyId"].toString(),
        'numberOfAppartment': numbOfAppController.toString(),
        'countyId': "1",
        'representativeId': null,
      }),
    );
    if (response.statusCode == 201) {
      var building = Building.fromJson(response.body);
      return building.buildingId;
    } else {
      throw Exception('Building loading failed!');
    }
  }
}
