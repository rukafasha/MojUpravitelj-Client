import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helper/global_url.dart';
import '../models/county.dart';

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
      return jsonResponse.map((county) => County.fromMap(county)).toList();
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
  
  Future<List<County>> getCountyByCountry(value) async{
  var url = Uri.parse('${GlobalUrl.url}county/country/$value');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((county) => County.fromMap(county)).toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<int> getCountyByName(value) async{
  var url = Uri.parse('${GlobalUrl.url}county/$value');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var county = County.fromMap(json.decode(response.body));
      return county.countyId;
    } else {
      throw Exception('Unexpected error occured');
    }
  }
}