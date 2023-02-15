import 'dart:convert';

import '../Helper/GlobalUrl.dart';
import '../Models/RequestModel.dart';

import 'package:http/http.dart' as http;

class RequestService {
  static var data;

  RequestService(readData) {
    data = readData;
  }

  Future<List<RequestModel>> getApartmentRequests() async {
    var personId = data["personId"];

    final response = await http.get(
      Uri.parse('${GlobalUrl.url}request/notApproved/$personId'),
    );

    final body = json.decode(response.body);

    return body.map<RequestModel>(RequestModel.fromJson).toList();
  }
}
