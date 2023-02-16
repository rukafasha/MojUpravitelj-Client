
import 'package:flutter/material.dart';
import 'package:praksa_frontend/Helper/RoleUtil.dart';
import 'package:praksa_frontend/Models/Building.dart';
import 'package:praksa_frontend/Services/PersonService.dart';
import '../../Models/Person.dart';
import 'buildingView_form.dart';
import 'list_of_apartments_in_the_building.dart';


class AppartmentView extends StatelessWidget {
  final Apartment apartment;
  final Building building;
  const AppartmentView(this.apartment, this.building, {super.key});

  @override
  Widget build(BuildContext context) { 
   var data = RoleUtil.GetData();

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => BuildingView(building)))),
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
                  subtitle: Text("Address: ${apartment.address}"),)
              ),
              
            ),
            Expanded(
                    child: FutureBuilder<List<Person>>(
                        future: getUsersInApartment(apartment),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            final users = snapshot.data!;
                            return buildUsers(users, context, building);
                          } else {
                             return const Text("Tenants not found.");
                          }
                }),
                ),
          ],
        )
    );
  }
}

Widget buildUsers(List<Person> users, dynamic context, Building building) =>
      ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          return  Card(
              child: ListTile(
                title: Text(" ${user.firstName} ${user.lastName}"),
                subtitle: Text("Date of birth: ${user.dateOfBirth.day}.${user.dateOfBirth.month}.${user.dateOfBirth.year}"),
              ),
            );
        },
      );

Future<List<Person>> getUsersInApartment(Apartment apartment) async {
  return await PersonService.getUsersByApartment(apartment);
}