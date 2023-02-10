import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Helper/GlobalUrl.dart';
import '../ui/forms/list_of_apartments_in_the_building.dart';

class AppartmentPersonService {
  static Future newOwner(int apartment_id, int person_id) async {
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}appartmentPerson/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'apartment_id': apartment_id.toString(),
        'person_id': person_id.toString(),
      }),
    );

    return response;
  }

  static Future<List<Apartment>> getAppartmentsByBuildingId(int buildingId) async{
    final response = await http.get(
      Uri.parse('${GlobalUrl.url}appartment/details/$buildingId'),
    );
    final body = json.decode(response.body);

    return body.map<Apartment>(Apartment.fromJson).toList();
  }
}
