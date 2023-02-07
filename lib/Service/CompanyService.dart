import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Helper/GlobalUrl.dart';
import '../Models/Company.dart';

class CompanyService{
  static var data;

  CompanyService(readData){
    data = readData;
  }


  Future<List<Company>> getAllCompany() async {

    var url = Uri.parse('${GlobalUrl.url}company');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((company) => Company.fromMap(company)).toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<Company> getCompanyById(int id) async{
    var url = Uri.parse('${GlobalUrl.url}company/$id');
    final response = await http.get(url);

    if(response.statusCode == 200){
      return Company.fromMap(json.decode(response.body));
    }else{
      throw Exception("Unexpected error ocured");
    }
  }

  Future<Company> addCountry(Company company) async{
     final response = await http.post(
      Uri.parse('${GlobalUrl.url}company/add'),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String,dynamic>{
        "companyName": company.companyName,
        "isActive": company.isActive,
      }),
    );

    if (response.statusCode == 200) {
    return Company.fromMap(json.decode(response.body));
  } else {
    throw Exception('Unexpected error occured');
  }
  }

  
  Future<Company> editCountry(Company company) async{
     final response = await http.put(
      Uri.parse('${GlobalUrl.url}company/edit/${company.companyId}'),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String,dynamic>{
        "companyName": company.companyName,
        "isActive": company.isActive,
      }),
    );

    if (response.statusCode == 200) {
    return Company.fromMap(json.decode(response.body));
  } else {
    throw Exception('Unexpected error occured');
  }
  }
}