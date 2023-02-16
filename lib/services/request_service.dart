import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helper/global_url.dart';
import '../models/request_model.dart';

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
