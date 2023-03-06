import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helper/global_url.dart';
import '../models/appartment.dart';
import '../ui/forms/list_of_apartments_in_the_building.dart';

class AppartmentService {
  Future<List<Appartment>> fetchApartments() async {
    var url = Uri.parse('${GlobalUrl.url}appartment/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((appartment) => Appartment.fromMap(appartment))
          .toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<Appartment> addAppartment(building, numbOfApps) async {
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}appartment/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'appartmentNumber': numbOfApps.toString(),
        'buildingId': building,
        'numberOfPeople': 0,
      }),
    );
    return Appartment.fromMap(json.decode(response.body));
  }

  Future<List<Apartment>> getAppartmentsWithoutPerson(
      appartmantsList, building_id) async {
    List<int> lista = List<int>.from(appartmantsList);
    final response = await http.post(
        Uri.parse('${GlobalUrl.url}appartment/withoutPerson'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, dynamic>{"lista": lista, "building_id": building_id}));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body.map<Apartment>(Apartment.fromJson).toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }
}
