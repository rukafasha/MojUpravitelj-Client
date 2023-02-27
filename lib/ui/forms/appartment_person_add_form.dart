import 'package:flutter/material.dart';
import 'package:praksa_frontend/helper/role_util.dart';
import 'package:praksa_frontend/ui/forms/user_form.dart';
import '../../models/appartment_person.dart';
import '../../services/appartment_person_service.dart';
import '../../services/appartment_service.dart';

class AddAppartmentPersonForm extends StatefulWidget {
  const AddAppartmentPersonForm({Key? key}) : super(key: key);

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
                  MaterialPageRoute(builder: (context) => const UserForm()),
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
                  future: fetchAppartments(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final appartments = snapshot.data!;
                      return buildAppartment(appartments, context);
                    } else {
                      return const Text("Appartments not found.");
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppartment(List<dynamic> appartments, dynamic context) =>
      ListView.builder(
        shrinkWrap: true,
        itemCount: appartments.length,
        itemBuilder: (context, index) {
          final appartment = appartments[index];
          return Card(
              child: Column(
            children: [
              ListTile(
                title: Text("Appartman: ${appartment.appartmentId}"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: FloatingActionButton(
                      heroTag: null,
                      backgroundColor: const Color(0xfff8a55f),
                      onPressed: () async {
                        debugPrint(appartment.appartmentId.toString());
                        await addAppartmentPerson(appartment.appartmentId);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UserForm()));
                      },
                      child: const Icon(Icons.save),
                    ),
                  ),
                ],
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

fetchAppartments() async {
  var data = RoleUtil.getData();
  List appartmantId = [];

  List<AppartmentPerson> lista =
      await AppartmentPersonService(data).fetchAppartmentsByPerson();
  for (var i = 0; i < lista.length; i++) {
    appartmantId.add(lista[i].appartmentId);
  }
  return AppartmentService().getAppartmentsWithoutPerson(appartmantId);
}
