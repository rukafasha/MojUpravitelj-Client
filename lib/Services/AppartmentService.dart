import 'dart:convert';

import '../Helper/GlobalUrl.dart';
import '../Models/Appartment.dart';

class AppartmentService {
  get http => null;

  Future<Appartment> AddAppartment(building, numbOfApps) async {
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}appartment/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'appartmentNumber': numbOfApps.toString(),
        'buildingId': building,
        'numberOfPeople': 0,
        'isActive': true,
      }),
    );
    return Appartment.fromMap(json.decode(response.body));
  }
}
