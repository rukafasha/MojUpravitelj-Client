import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:praksa_frontend/Models/AppartmentPerson.dart';
import 'package:praksa_frontend/Services/AppartmentPersonService.dart';
import 'package:praksa_frontend/Services/AppartmentService.dart';
import 'package:praksa_frontend/Services/Auth/AuthService.dart';
import 'package:praksa_frontend/ui/forms/buildings_by_address.dart';
import 'package:praksa_frontend/ui/forms/login_form.dart';
import 'package:praksa_frontend/ui/forms/register_form.dart';
import 'package:http/http.dart' as http;
import '../../Helper/GlobalUrl.dart';

class Apartment {
  final int buildingId;
  final int apartmentId;
  final int apartmentNumber;
  final String address;

  const Apartment({
    required this.buildingId,
    required this.apartmentId,
    required this.apartmentNumber,
    required this.address,
  });

  static Apartment fromJson(json) => Apartment(
        buildingId: json["buildingId"],
        apartmentId: json["apartmentId"],
        apartmentNumber: json["apartmentNumber"],
        address: json["address"],
      );
}

class ListOfApartmentsInTheBuilding extends StatefulWidget {
  final building_id;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController dateController;

  ListOfApartmentsInTheBuilding({
    super.key,
    required this.building_id,
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.passwordController,
    required this.dateController,
  });

  @override
  State<ListOfApartmentsInTheBuilding> createState() =>
      _ListOfApartmentsInTheBuildingState();
}

class _ListOfApartmentsInTheBuildingState
    extends State<ListOfApartmentsInTheBuilding> {
  late Future<List<Apartment>> apartmentsFuture;
  var _building_id, _person_id;

  @override
  void initState() {
    super.initState();
    _building_id = widget.building_id;
    apartmentsFuture = getListOfApartmentsInTheBuilding(widget.building_id);
  }

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
                  builder: (context) => BuildingsByAddress(
                        firstNameController: widget.firstNameController,
                        lastNameController: widget.lastNameController,
                        usernameController: widget.usernameController,
                        passwordController: widget.passwordController,
                        dateController: widget.dateController,
                      )))),
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
                            return buildApartments(apartments, context);
                          } else {
                            return const Text("Apartments not found.");
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget buildApartments(List<Apartment> apartments, dynamic context) =>
      ListView.builder(
        itemCount: apartments.length,
        itemBuilder: (context, index) {
          final apartment = apartments[index];

          return Card(
            child: ListTile(
              onTap: () async {
                final response = await AuthService.userRegistration(
                  widget.firstNameController,
                  widget.lastNameController,
                  widget.usernameController,
                  widget.passwordController,
                  widget.dateController,
                );

                var person__id = json.decode(response.body);
                await newOwner(apartment.apartmentId, person__id, context);
              },
              title: Text("Apartment number: ${apartment.apartmentNumber}"),
              subtitle: Text("Address: ${apartment.address}"),
            ),
          );
        },
      );
}

Future newOwner(int apartment_id, int person_id, dynamic context) async {
  final response =
      await AppartmentPersonService.newOwner(apartment_id, person_id);
  if (response.statusCode >= 200 && response.statusCode < 300) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginForm(),
      ),
    );
  } else {
    throw Exception('Apartment registration failed!');
  }
}
