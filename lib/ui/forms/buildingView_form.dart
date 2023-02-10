
import 'package:flutter/material.dart';
import 'package:praksa_frontend/Helper/RoleUtil.dart';
import 'package:praksa_frontend/Models/Building.dart';
import 'package:praksa_frontend/Services/AppartmentPersonService.dart';
import '../../Models/Company.dart';
import '../../Services/CompanyService.dart';
import 'buildingAll_form.dart';
import 'buildingEdit_form.dart';
import 'list_of_apartments_in_the_building.dart';


class BuildingView extends StatelessWidget {
  final Building building;
  BuildingView(this.building, {super.key});

  @override
  Widget build(BuildContext context) { 
   var data = RoleUtil.GetData();

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const BuildingAll()))),
          title: const Center(child: Text("Moj upravitelj",)),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Color(0xfff8a55f),Color(0xfff1665f)]),
              ),
            ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<Company>(
                future: fetchCompany(building.companyId),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                  return ListView(
                    children: <Widget>[
                      Container(
                        height: 300,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[Color(0xfff8a55f),Color(0xfff1665f)],
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
                    ]
                  );
                  }else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const CircularProgressIndicator();
                      }
              ),
            ),
              Expanded(
                child: Center(
                    child: FutureBuilder<List<Apartment>>(
                        future: getListOfApartmentsInTheBuilding(building.buildingId),
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
        floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xfff8a55f),
              onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => BuildingEdit(building)));},
              child: const Icon(Icons.edit)
            )
    );
  }
}
Widget buildApartments(List<Apartment> apartments, dynamic context) =>
      ListView.builder(
        itemCount: apartments.length,
        itemBuilder: (context, index) {
          final apartment = apartments[index];

          return Card(
            child: ListTile(
              title: Text("Apartment number: ${apartment.apartmentNumber}"),
              subtitle: Text("Address: ${apartment.address}"),
            ),
          );
        },
      );
Future<Company> fetchCompany(int id) async {
  var data = RoleUtil.GetData();
  return CompanyService(data).getCompanyById(id);
}

Future<List<Apartment>> getListOfApartmentsInTheBuilding(buildingId) async {
    return await AppartmentPersonService.getAppartmentsByBuildingId(buildingId);
  }