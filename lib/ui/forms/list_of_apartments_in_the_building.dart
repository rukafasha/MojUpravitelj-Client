import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:praksa_frontend/ui/forms/buildings_by_address.dart';
import 'package:praksa_frontend/ui/forms/register_form.dart';
import 'package:http/http.dart' as http;

import '../../Helper/GlobalUrl.dart';

class Apartment {
  final int buildingId;
  final int apartmentNumber;
  final String address;

  const Apartment({
    required this.buildingId,
    required this.apartmentNumber,
    required this.address,
  });

  static Apartment fromJson(json) => Apartment(
        buildingId: json["buildingId"],
        apartmentNumber: json["apartmentNumber"],
        address: json["address"],
      );
}

class ListOfApartmentsInTheBuilding extends StatefulWidget {
  var building_id;
  var user_id;
  ListOfApartmentsInTheBuilding(
      {super.key, required this.building_id, required this.user_id});

  @override
  State<ListOfApartmentsInTheBuilding> createState() =>
      _ListOfApartmentsInTheBuildingState();
}

class _ListOfApartmentsInTheBuildingState
    extends State<ListOfApartmentsInTheBuilding> {
  // late Future<List<Apartment>> apartmentsFuture = Future.value([]);
  late Future<List<Apartment>> apartmentsFuture;
  var apartmentsNotFound = "Apartments not found.";
  var _building_id;

  @override
  void initState() {
    super.initState();
    _building_id = widget.building_id;
    apartmentsFuture = getListOfApartmentsInTheBuilding(widget.building_id);

    // _user_id = widget.user_id;
  }

  // Future addApartment(String apartment_id) async {
  //   var map = <String, dynamic>{};
  //   map['apartment_id'] = apartment_id;
  //   map['user_id'] = _user_id;

  //   final response = await http.post(
  //     Uri.parse('${GlobalUrl.url}testna'),
  //     body: map,
  //   );

  //   return response.statusCode;
  // }

  Future<List<Apartment>> getListOfApartmentsInTheBuilding(building_id) async {
    final response = await http.get(
      Uri.parse('${GlobalUrl.url}appartment/details/$building_id'),
    );
    final body = json.decode(response.body);

    return body.map<Apartment>(Apartment.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: BackButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BuildingsByAddress(user_id: 2)))),
          title: const Text(
            "Apartments",
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xfff8a55f), Color(0xfff1665f)]),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                    child: FutureBuilder<List<Apartment>>(
                        future: apartmentsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            final apartments = snapshot.data!;
                            return buildApartments(apartments);
                          } else {
                            return Text(apartmentsNotFound);
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget buildApartments(List<Apartment> apartments) => ListView.builder(
        itemCount: apartments.length,
        itemBuilder: (context, index) {
          final apartment = apartments[index];

          return Card(
            child: ListTile(
              onTap: () {
                print("building_id: ${apartment.buildingId}");
                // print("user_id: $_user_id");
              },
              title: Text(
                  "Building ID: ${apartment.buildingId}   |   Apartment number: ${apartment.apartmentNumber}"),
              subtitle: Text("Address: ${apartment.address}"),
            ),
          );
        },
      );
}
