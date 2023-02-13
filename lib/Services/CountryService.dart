import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Helper/GlobalUrl.dart';
import '../Models/Country.dart';

class CountryService {
  static var data;

  CountryService(readData) {
    data = readData;
  }

  Future<List<Country>> getAllCountry() async {
    var url = Uri.parse('${GlobalUrl.url}country/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((country) => Country.fromMap(country)).toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<Country> getCountryById(int id) async {
    var url = Uri.parse('${GlobalUrl.url}country/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Country.fromMap(json.decode(response.body));
    } else {
      throw Exception("Unexpected error ocured");
    }
  }

  Future<Country> addCountry(Country country) async {
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}country/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "countryName": country.countryName,
      }),
    );

    if (response.statusCode == 200) {
      return Country.fromMap(json.decode(response.body));
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<Country> editCountry(Country country) async {
    final response = await http.put(
      Uri.parse('${GlobalUrl.url}country/edit/${country.countryId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "countryName": country.countryName,
      }),
    );

    if (response.statusCode == 200) {
      return Country.fromMap(json.decode(response.body));
    } else {
      throw Exception('Unexpected error occured');
    }
  }
}
