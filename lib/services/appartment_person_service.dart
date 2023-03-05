import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helper/global_url.dart';
import '../helper/role_util.dart';
import '../models/appartment_person.dart';
import '../ui/forms/list_of_apartments_in_the_building.dart';

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

  static Future newOwner(int apartmentid, int personid) async {
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}appartmentPerson/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'apartment_id': apartmentid.toString(),
        'person_id': personid.toString(),
      }),
    );

    return response;
  }

  static Future<List<Apartment>> getAppartmentsByBuildingId(
      int buildingId) async {
    final response = await http.get(
      Uri.parse('${GlobalUrl.url}appartment/details/$buildingId'),
    );
    final body = json.decode(response.body);

    return body.map<Apartment>(Apartment.fromJson).toList();
  }

  Future<int> addAppartmentPeron(appartmentId) async {
    var data = RoleUtil.getData();
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}appartmentPerson/addByTenant'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'person_id': data["personId"],
        'apartment_id': appartmentId,
      }),
    );
    if (response.statusCode < 300) {
      return response.statusCode;
    } else {
      throw Exception('Unexpected error occured');
    }
  }
}
