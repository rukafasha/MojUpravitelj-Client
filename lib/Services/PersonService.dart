import 'dart:convert';

import '../Helper/GlobalUrl.dart';
import '../Models/Person.dart';
import 'package:http/http.dart' as http;

import '../ui/forms/list_of_apartments_in_the_building.dart';

class PersonService {
  static Future<Person> fetchUserById(int id) async {
    var url = Uri.parse('${GlobalUrl.url}person/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Person.fromMap(json.decode(response.body));
    } else {
      throw Exception('Unexpected error occured');
    }
  }

 static Future<String> fetchUsersName(int id) async {
    var url = Uri.parse('${GlobalUrl.url}person/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var person = Person.fromMap(json.decode(response.body));
      return "${person.firstName} ${person.lastName}";
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  static Future<List<Person>> getUsersByApartment(Apartment apartment) async{
    var url = Uri.parse('${GlobalUrl.url}person/get/apartment/${apartment.apartmentId}');
    final response = await http.get(url);

    
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((person) => Person.fromMap(person)).toList();
    
  }
}
