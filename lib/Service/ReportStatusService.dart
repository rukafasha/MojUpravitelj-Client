import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Helper/GlobalUrl.dart';
import '../Models/ReportStatus.dart';

class ReportStatusService{
  static var data;

  ReportStatusService(readData){
    data = readData;
  }


  Future<List<ReportStatus>> getAllCountry() async {

    var url = Uri.parse('${GlobalUrl.url}reportStatus');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((reportStatus) => ReportStatus.fromMap(reportStatus)).toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<ReportStatus> getCountryById(int id) async{
    var url = Uri.parse('${GlobalUrl.url}reportStatus/$id');
    final response = await http.get(url);

    if(response.statusCode == 200){
      return ReportStatus.fromMap(json.decode(response.body));
    }else{
      throw Exception("Unexpected error ocured");
    }
  }

  Future<ReportStatus> addCountry(ReportStatus reportStatus) async{
     final response = await http.post(
      Uri.parse('${GlobalUrl.url}reportStatus/add'),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String,dynamic>{
        "statusDescription": reportStatus.statusDescription,
      }),
    );

    if (response.statusCode == 200) {
    return ReportStatus.fromMap(json.decode(response.body));
  } else {
    throw Exception('Unexpected error occured');
  }
  }

  
  Future<ReportStatus> editCountry(ReportStatus reportStatus) async{
     final response = await http.put(
      Uri.parse('${GlobalUrl.url}reportStatus/edit/${reportStatus.reportStatusId}'),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String,dynamic>{
        "statusDescription": reportStatus.statusDescription,
      }),
    );

    if (response.statusCode == 200) {
    return ReportStatus.fromMap(json.decode(response.body));
  } else {
    throw Exception('Unexpected error occured');
  }
  }
}