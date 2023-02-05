import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:praksa_frontend/Helper/RoleUtil.dart';
import 'package:praksa_frontend/ui/forms/list_of_apartments_in_the_building.dart';
import 'package:praksa_frontend/ui/forms/login_form.dart';
import 'package:http/http.dart' as http;
import 'package:praksa_frontend/ui/forms/register_form.dart';

import '../../Helper/GlobalUrl.dart';

class ModelBuildingsByAddress {
  final int buildingId;
  final String address;
  final int numberOfApartments;
  final String countyName;
  final String countryName;
  final int representativeId;
  final String representativeFirstName;
  final String representativeLastName;
  final int companyId;
  final String companyName;

  const ModelBuildingsByAddress({
    required this.buildingId,
    required this.address,
    required this.numberOfApartments,
    required this.countyName,
    required this.countryName,
    required this.representativeId,
    required this.representativeFirstName,
    required this.representativeLastName,
    required this.companyId,
    required this.companyName,
  });

  static ModelBuildingsByAddress fromJson(json) => ModelBuildingsByAddress(
        buildingId: json["buildingId"],
        address: json["address"],
        numberOfApartments: json["numberOfApartments"],
        countyName: json["countyName"],
        countryName: json["countryName"],
        representativeId: json["representativeId"],
        representativeFirstName: json["representativeFirstName"],
        representativeLastName: json["representativeLastName"],
        companyId: json["companyId"],
        companyName: json["companyName"],
      );
}

class BuildingsByAddress extends StatefulWidget {
  var user_id;
  BuildingsByAddress({super.key, required this.user_id});

  @override
  State<BuildingsByAddress> createState() => _BuildingsByAddressState();
}

class _BuildingsByAddressState extends State<BuildingsByAddress> {
  late Future<List<ModelBuildingsByAddress>> buildingsFuture = Future.value([]);
  final _searchController = TextEditingController();
  var buildingsNotFound = "Buildings not found.";
  var _user_id;

  @override
  void initState() {
    super.initState();
    _user_id = widget.user_id;
  }

  Future<List<ModelBuildingsByAddress>> getBuildingsByAddress(address) async {
    final response = await http.get(
      Uri.parse('${GlobalUrl.url}building/details/$address'),
    );

    final body = json.decode(response.body);

    return body
        .map<ModelBuildingsByAddress>(ModelBuildingsByAddress.fromJson)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: BackButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RegisterForm()))),
          title: const Text(
            "Buildings",
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
              Center(
                child: TextFormField(
                  controller: _searchController,
                  // validator: (value) {
                  //   if (value!.trim().isEmpty) {
                  //     return "Enter Address";
                  //   }
                  // },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 219, 218, 218),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Enter Address",
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.purple.shade900,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 5, 127, 214),
                  ),
                  onPressed: () {
                    if (_searchController.text.trim().isEmpty) {
                      setState(() {
                        buildingsFuture = Future.value([]);
                      });
                    } else {
                      setState(() {
                        buildingsFuture =
                            getBuildingsByAddress(_searchController.text);
                      });
                    }
                  },
                  child: const Text('Dobavi podatke'),
                ),
              ),
              Expanded(
                child: Center(
                    child: FutureBuilder<List<ModelBuildingsByAddress>>(
                        future: buildingsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            final apartments = snapshot.data!;
                            return buildApartments(apartments);
                          } else {
                            return Text(buildingsNotFound);
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget buildApartments(List<ModelBuildingsByAddress> buildings) =>
      ListView.builder(
        itemCount: buildings.length,
        itemBuilder: (context, index) {
          final building = buildings[index];

          return Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ListOfApartmentsInTheBuilding(
                        building_id: building.buildingId, user_id: _user_id),
                  ),
                );
                print("building_id: ${building.buildingId}");
                print("user_id: $_user_id");
              },
              title: Text(
                  "Building ID: ${building.buildingId}   |   County: ${building.countyName}"),
              subtitle: Text(
                  "Company name: ${building.companyName}   |   NoA: ${building.numberOfApartments}"),
            ),
          );
        },
      );
}
