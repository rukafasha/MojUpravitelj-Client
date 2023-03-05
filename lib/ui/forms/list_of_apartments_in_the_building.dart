import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import '../../services/appartment_person_service.dart';
import '../../services/auth/auth_service.dart';
import '../../ui/forms/buildings_by_address.dart';
import '../../ui/forms/login_form.dart';

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
  final Crypt hashedPwd;
  final TextEditingController dateController;

  ListOfApartmentsInTheBuilding({
    super.key,
    required this.building_id,
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.hashedPwd,
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
    return await AppartmentPersonService.getAppartmentsByBuildingId(
        building_id);
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
                        hashedPwd: widget.hashedPwd,
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
              shape: RoundedRectangleBorder(
                  side:
                      BorderSide(width: 2, color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(20)),
              onTap: () async {
                final response = await AuthService.userRegistration(
                  widget.firstNameController,
                  widget.lastNameController,
                  widget.usernameController,
                  widget.hashedPwd,
                  widget.dateController,
                );

                var person__id = json.decode(response.body);
                await newOwner(apartment.apartmentId, person__id, context);
              },
              leading: Icon(Icons.home, color: Color(0xfff8a55f)),
              title: Text("Apartment number: ${apartment.apartmentNumber}"),
              subtitle: Text("Address: ${apartment.address}"),
              trailing: Icon(Icons.add, color: Color(0xfff8a55f)),
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
