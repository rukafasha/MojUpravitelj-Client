import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';

import '../../helper/role_util.dart';
import '../../models/model_buildings_by_address.dart';
import '../../services/building_service.dart';

import '../../ui/forms/list_of_apartments_in_the_building.dart';
import '../../ui/forms/register_form.dart';

class BuildingsByAddress extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final Crypt hashedPwd;
  final TextEditingController dateController;

  const BuildingsByAddress({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.hashedPwd,
    required this.dateController,
  });

  @override
  State<BuildingsByAddress> createState() => _BuildingsByAddressState();
}

class _BuildingsByAddressState extends State<BuildingsByAddress> {
  late Future<List<ModelBuildingsByAddress>> buildingsFuture = Future.value([]);
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<List<ModelBuildingsByAddress>> getBuildingsByAddress(address) async {
    var data = RoleUtil.getData();
    return await BuildingService(data).getBuildingsByAddress(address);
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
                    padding: const EdgeInsets.all(15),
                    backgroundColor: const Color(0xfff1665f),
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
                  child: const Text('Search'),
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
                            final buildings = snapshot.data!;
                            return buildBuildings(buildings);
                          } else {
                            return const Text("Buildings not found.");
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget buildBuildings(List<ModelBuildingsByAddress> buildings) =>
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
                      building_id: building.buildingId,
                      firstNameController: widget.firstNameController,
                      lastNameController: widget.lastNameController,
                      usernameController: widget.usernameController,
                      hashedPwd: widget.hashedPwd,
                      dateController: widget.dateController,
                    ),
                  ),
                );
              },
              contentPadding: EdgeInsets.all(10),
              leading: Icon(Icons.business, color: Color(0xfff8a55f)),
              title: Text("Building: ${building.buildingId}"),
              subtitle: Text(
                  "Company: ${building.companyName}\n${building.numberOfApartments} apartments"),
              trailing: Icon(Icons.arrow_forward, color: Color(0xfff8a55f)),
            ),
          );
        },
      );
}
