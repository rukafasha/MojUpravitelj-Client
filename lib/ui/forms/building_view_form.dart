import 'package:flutter/material.dart';

import '../../helper/role_util.dart';
import '../../models/appartment.dart';
import '../../models/building.dart';
import '../../models/company.dart';
import '../../services/appartment_person_service.dart';
import '../../services/appartment_service.dart';
import '../../services/building_service.dart';
import '../../services/company_service.dart';
import '../../ui/forms/apartment_view.dart';
import 'building_all_form.dart';
import 'building_edit_form.dart';
import 'list_of_apartments_in_the_building.dart';

class BuildingView extends StatelessWidget {
  final Building building;
  const BuildingView(this.building, {super.key});

  @override
  Widget build(BuildContext context) {
    var data = RoleUtil.getData();

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const BuildingAll()))),
          title: const Center(
              child: Text(
            "Moj upravitelj",
          )),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xfff8a55f), Color(0xfff1665f)]),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<Company>(
                  future: fetchCompany(building.companyId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(children: <Widget>[
                        Container(
                          height: 240,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xfff8a55f),
                                Color(0xfff1665f)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: [0.5, 0.9],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                building.address,
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                snapshot.data!.companyName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  List<Apartment> lista =
                                      await getListOfApartmentsInTheBuilding(
                                          building.buildingId);
                                  await addAppartment(
                                      building.buildingId, lista.length);
                                  Building building2 =
                                      await updateNumbOfAppsInBuilding(
                                          building);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          BuildingView(building2)));
                                },
                                child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: <Color>[
                                          Color(0xfff8a55f),
                                          Color(0xfff1665f)
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: [0.5, 0.9],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              4), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Add new apartment",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ]);
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return const CircularProgressIndicator();
                  }),
            ),
            Expanded(
              child: FutureBuilder<List<Apartment>>(
                  future: getListOfApartmentsInTheBuilding(building.buildingId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final apartments = snapshot.data!;
                      return buildApartments(apartments, context, building);
                    } else {
                      return const Text("Apartments not found.");
                    }
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xfff8a55f),
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BuildingEdit(building)));
            },
            child: const Icon(Icons.edit)));
  }
}

Widget buildApartments(
        List<Apartment> apartments, dynamic context, Building building) =>
    ListView.builder(
      itemCount: apartments.length,
      itemBuilder: (context, index) {
        final apartment = apartments[index];

        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AppartmentView(apartment, building)));
          },
          child: Card(
            child: ListTile(
              shape: RoundedRectangleBorder(
                  side:
                      BorderSide(width: 2, color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(20)),
              leading: Icon(Icons.home, color: Color(0xfff8a55f)),
              title: Text("Apartment number: ${apartment.apartmentNumber}"),
              subtitle: Text("Address: ${apartment.address}"),
              trailing: Icon(Icons.arrow_forward, color: Color(0xfff8a55f)),
            ),
          ),
        );
      },
    );

Future<Company> fetchCompany(int id) async {
  var data = RoleUtil.getData();
  return CompanyService(data).getCompanyById(id);
}

Future<List<Apartment>> getListOfApartmentsInTheBuilding(buildingId) async {
  return await AppartmentPersonService.getAppartmentsByBuildingId(buildingId);
}

Future<Appartment> addAppartment(int buildingId, int list) async {
  return await AppartmentService().addAppartment(buildingId, list + 1);
}

Future<Building> updateNumbOfAppsInBuilding(Building building) async {
  var data = RoleUtil.getData();

  Building rep = Building(
    address: building.address,
    buildingId: building.buildingId,
    companyId: building.companyId,
    countyId: building.countyId,
    numberOfAppartment: (building.numberOfAppartment + 1),
  );

  return await BuildingService(data).editBuilding(rep);
}
