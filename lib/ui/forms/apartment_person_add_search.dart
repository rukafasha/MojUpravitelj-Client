import 'package:flutter/material.dart';

import '../../helper/role_util.dart';
import '../../models/model_buildings_by_address.dart';
import '../../services/building_service.dart';
import '../../ui/forms/appartment_person_add_form.dart';
import '../../ui/forms/user_form.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({
    super.key,
  });

  @override
  State<SearchForm> createState() => _SearchForm();
}

class _SearchForm extends State<SearchForm> {
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
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UserForm()))),
          title: const Text("Buildings"),
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
                    prefixIconColor: Color(0xfff1665f),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
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
              contentPadding: EdgeInsets.all(10),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddAppartmentPersonForm(
                    building_id: building.buildingId,
                  ),
                ));
              },
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
