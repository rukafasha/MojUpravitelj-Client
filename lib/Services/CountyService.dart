import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Helper/GlobalUrl.dart';
import '../Models/County.dart';

class CountyService {
  static var data;

  CountyService(readData) {
    data = readData;
  }

  Future<List<County>> getAllCountry() async {
    var url = Uri.parse('${GlobalUrl.url}county');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((country) => County.fromMap(country)).toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<County> getCountryById(int id) async {
    var url = Uri.parse('${GlobalUrl.url}county/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return County.fromMap(json.decode(response.body));
    } else {
      throw Exception("Unexpected error ocured");
    }
  }

  Future<County> addCountry(County county) async {
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}county/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "countyName": county.countyName,
      }),
    );

    if (response.statusCode == 200) {
      return County.fromMap(json.decode(response.body));
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<County> editCountry(County county) async {
    final response = await http.put(
      Uri.parse('${GlobalUrl.url}county/edit/${county.countyId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "countryName": county.countyName,
      }),
    );

    if (response.statusCode == 200) {
      return County.fromMap(json.decode(response.body));
    } else {
      throw Exception('Unexpected error occured');
    }
  }
}
