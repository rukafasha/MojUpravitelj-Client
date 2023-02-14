import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:praksa_frontend/Helper/RoleUtil.dart';

import '../Helper/GlobalUrl.dart';
import '../Models/Report.dart';
import 'ReportStatusService.dart';

class ReportService {
  static var data;

  ReportService(readData) {
    data = readData;
  }

  Future<List<Report>> getAllReport() async {
    var url = Uri.parse('${GlobalUrl.url}report');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((report) => Report.fromMap(report)).toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<Report> getReportById(int id) async {
    var url = Uri.parse('${GlobalUrl.url}report/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Report.fromMap(json.decode(response.body));
    } else {
      throw Exception("Unexpected error ocured");
    }
  }

  Future<Report> addReport(Report report) async {
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}report/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': report.title.toString(),
        'description': report.description.toString(),
        'madeBy': report.madeBy,
        'timeCreated': report.timeCreated.toString(),
        'timeFinished': report.timeFinished,
        'status': report.status,
        'closedBy': report.closedBy,
      }),
    );
    if (response.statusCode == 201) {
      return Report.fromMap(json.decode(response.body));
    } else {
      throw Exception('Report loading failed!');
    }
  }

  Future<Report> editReport(Report report) async {
    final response = await http.put(
      Uri.parse('${GlobalUrl.url}report/edit/${report.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': report.title.toString(),
        'description': report.description.toString(),
        'madeBy': report.madeBy,
        'timeCreated': report.timeCreated.toString(),
        'timeFinished': report.timeFinished,
        'status': report.status,
        'closedBy': report.closedBy,
      }),
    );

    if (response.statusCode == 200) {
      return Report.fromMap(json.decode(response.body));
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  
  Future<Report> changeReportStatus(Report report, String? status) async {
    http.Response response;
    var statusId = await ReportStatusService(data).getStatusId(status);
    if(status == "closed"){
      response = await http.put(
      Uri.parse('${GlobalUrl.url}report/edit/${report.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': report.title.toString(),
        'description': report.description.toString(),
        'madeBy': report.madeBy,
        'timeCreated': report.timeCreated.toString(),
        'timeFinished': DateTime.now().toString(),
        'status': statusId,
        'closedBy': data["personId"],
      }),
    );
    }else{
      response = await http.put(
      Uri.parse('${GlobalUrl.url}report/edit/${report.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': report.title.toString(),
        'description': report.description.toString(),
        'madeBy': report.madeBy,
        'timeCreated': report.timeCreated.toString(),
        'timeFinished': report.timeFinished,
        'status': statusId,
        'closedBy': report.closedBy,
      }),
    );
    }

    if (response.statusCode == 200) {
      return Report.fromMap(json.decode(response.body));
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<List<Report>> getReportByBuilding(listaZgrada, filter) async {
    List<int> lista = List<int>.from(listaZgrada);
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}report/get/building'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String,dynamic>{
          "lista": lista,
          "filter": filter
        }
      )
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((report) => Report.fromMap(report)).toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<List<Report>> getReportByCompany(companyId, filter) async {
    var url = Uri.parse('${GlobalUrl.url}report/get/company');
    final response = await http.post(
      Uri.parse('${GlobalUrl.url}report/get/company/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String,dynamic>{
          "lista": companyId,
          "filter": filter
        }
      )
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((report) => Report.fromMap(report)).toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<List<Report>> getReportByUser(userId) async {
    var url = Uri.parse('${GlobalUrl.url}report/get/user/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((report) => Report.fromMap(report)).toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<http.Response> deleteReport(Report report) async {
    final http.Response response = await http.delete(
      Uri.parse('${GlobalUrl.url}report/delete/${report.id}'),
    );

    return response;
  }
}
