import 'dart:convert';

import '../helper/global_url.dart';
import '../models/appartment.dart';
import 'package:http/http.dart' as http;

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
}
