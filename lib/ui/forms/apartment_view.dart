import 'package:flutter/material.dart';

import '../../helper/role_util.dart';
import '../../models/building.dart';
import '../../models/person.dart';
import '../../services/building_service.dart';
import '../../services/person_service.dart';
import '../../services/role_person_service.dart';
import '../../services/roles_service.dart';

import 'building_view_form.dart';
import 'list_of_apartments_in_the_building.dart';

class AppartmentView extends StatelessWidget {
  final Apartment apartment;
  final Building building;
  const AppartmentView(this.apartment, this.building, {super.key});

  @override
  Widget build(BuildContext context) {
    var data = RoleUtil.getData();

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BuildingView(building)))),
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
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                  child: ListTile(
                title: Text("Appartment number: ${apartment.apartmentNumber}"),
                subtitle: Text("Address: ${apartment.address}"),
              )),
            ),
            Expanded(
              child: FutureBuilder<List<Person>>(
                  future: getUsersInApartment(apartment),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final users = snapshot.data!;
                      return buildUsers(users, context, building);
                    } else {
                      return const Text("Tenants not found.");
                    }
                  }),
            ),
          ],
        ));
  }
}

Widget buildUsers(List<Person> users, dynamic context, Building building) =>
    ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return Card(
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(" ${user.firstName} ${user.lastName}"),
                  subtitle: Text(
                      "Date of birth: ${user.dateOfBirth.day}.${user.dateOfBirth.month}.${user.dateOfBirth.year}"),
                ),
              ),
              InkWell(
                onTap: () async {
                  var building2 = await addRepresentative(user, building);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BuildingView(building2)));
                },
                child: const Icon(Icons.add),
              )
            ],
          ),
        );
      },
    );

Future<List<Person>> getUsersInApartment(Apartment apartment) async {
  return await PersonService.getUsersByApartment(apartment);
}

Future<Building> addRepresentative(Person person, Building b) async {
  var data = RoleUtil.getData();
  Building building = Building(
      buildingId: b.buildingId,
      address: b.address,
      numberOfAppartment: b.numberOfAppartment,
      countyId: b.countyId,
      companyId: b.companyId,
      representativeId: person.personId);
  var roleId = await RoleService.getByString("Representative");
  await RolePersonService.addRepresentativeRole(person.personId, roleId);
  return await BuildingService(data).addRepresentative(building);
}
