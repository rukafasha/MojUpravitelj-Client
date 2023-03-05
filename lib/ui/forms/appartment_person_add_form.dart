import 'package:flutter/material.dart';
import 'package:praksa_frontend/ui/forms/list_of_apartments_in_the_building.dart';

import '../../helper/role_util.dart';
import '../../models/appartment_person.dart';
import '../../services/appartment_person_service.dart';
import '../../services/appartment_service.dart';
import '../../ui/forms/apartment_person_add_search.dart';
import '../../ui/forms/user_form.dart';

class AddAppartmentPersonForm extends StatefulWidget {
  final int building_id;

  const AddAppartmentPersonForm({Key? key, required this.building_id})
      : super(key: key);

  @override
  State<AddAppartmentPersonForm> createState() => _AddAppartmentPersonForm();
}

class _AddAppartmentPersonForm extends State<AddAppartmentPersonForm> {
  late final AsyncSnapshot<List<AppartmentPerson>> snapshot;
  late final int index;
  var data = RoleUtil.getData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchForm()),
                )),
        title: const Center(child: Text("Add Apartment")),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Color(0xfff8a55f), Color(0xfff1665f)]),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: FutureBuilder<dynamic>(
                  future: fetchAppartments(widget.building_id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final appartments = snapshot.data!;
                      return buildAppartment(appartments, context);
                    } else {
                      return const Text("Apartments not found.");
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppartment(List<Apartment> appartments, dynamic context) =>
      ListView.builder(
        shrinkWrap: true,
        itemCount: appartments.length,
        itemBuilder: (context, index) {
          final appartment = appartments[index];
          return Card(
              shadowColor: Colors.grey.withOpacity(0.5),
              child: Column(
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 2, color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Icons.home, color: Color(0xfff8a55f)),
                    title:
                        Text("Apartment number: ${appartment.apartmentNumber}"),
                    subtitle: Text("Address: ${appartment.address}"),
                    trailing: IconButton(
                        icon: Icon(Icons.add),
                        color: Color(0xfff1665f),
                        onPressed: () => {
                              addAppartmentPerson(appartment.apartmentId),
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const UserForm()))
                            }),
                  ),
                ],
              ));
        },
      );
}

addAppartmentPerson(appartment) async {
  var data = RoleUtil.getData();
  return AppartmentPersonService(data).addAppartmentPeron(appartment);
}

fetchAppartments(building_id) async {
  var data = RoleUtil.getData();
  List appartmantId = [];

  List<AppartmentPerson> lista =
      await AppartmentPersonService(data).fetchAppartmentsByPerson();
  for (var i = 0; i < lista.length; i++) {
    appartmantId.add(lista[i].appartmentId);
  }
  return AppartmentService()
      .getAppartmentsWithoutPerson(appartmantId, building_id);
}
