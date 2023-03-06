import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helper/global_url.dart';
import '../models/building.dart';
import '../models/model_buildings_by_address.dart';

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

  Future<int> addBuilding(
      addressController, numbOfAppController, dropDownValueOpstina) async {
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}building/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'address': addressController.toString(),
        'companyId': data["companyId"].toString(),
        'numberOfAppartment': numbOfAppController.toString(),
        'countyId': dropDownValueOpstina,
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

  Future<Building> editBuilding(Building rep) async {
    final response = await http.put(
      Uri.parse('${GlobalUrl.url}building/edit/${rep.buildingId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'address': rep.address.toString(),
        'companyId': rep.companyId.toString(),
        'numberOfAppartment': rep.numberOfAppartment.toString(),
        'countyId': rep.countyId.toString(),
        'representativeId': rep.representativeId,
      }),
    );
    if (response.statusCode == 200) {
      return Building.fromJson(response.body);
    } else {
      throw Exception('Building loading failed!');
    }
  }

  Future<Building> addRepresentative(Building rep) async {
    final response = await http.put(
      Uri.parse('${GlobalUrl.url}building/edit/${rep.buildingId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'address': rep.address.toString(),
        'companyId': rep.companyId.toString(),
        'numberOfAppartment': rep.numberOfAppartment.toString(),
        'countyId': rep.countyId.toString(),
        'representativeId': rep.representativeId.toString(),
      }),
    );
    if (response.statusCode == 200) {
      return Building.fromJson(response.body);
    } else {
      throw Exception('Building loading failed!');
    }
  }

  Future buildingDelete(Building building) async {
    final http.Response response = await http.delete(
      Uri.parse('${GlobalUrl.url}building/delete/${building.buildingId}'),
    );
  }

  Future<List<ModelBuildingsByAddress>> getBuildingsByAddress(address) async {
    final response = await http.get(
      Uri.parse('${GlobalUrl.url}building/details/$address'),
    );

    final body = json.decode(response.body);
    return body
        .map<ModelBuildingsByAddress>(ModelBuildingsByAddress.fromJson)
        .toList();
  }
}
