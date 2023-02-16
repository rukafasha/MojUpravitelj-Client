import 'package:flutter/material.dart';
import 'package:praksa_frontend/helper/role_util.dart';
import 'package:praksa_frontend/models/appartment.dart';
import 'package:praksa_frontend/services/appartment_service.dart';
import 'package:praksa_frontend/services/building_service.dart';
import 'package:praksa_frontend/ui/forms/building_view_form.dart';
import 'package:praksa_frontend/ui/forms/home_form.dart';

class BuildingAdd extends StatelessWidget {
  const BuildingAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomePage()))),
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
      body: const AddForm(),
    );
  }
}

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  AddFormState createState() {
    return AddFormState();
  }
}

class AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _numbOfAppController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.short_text),
                    hintText: 'Enter address for building',
                    labelText: 'Address',
                  ),
                  validator: (String? value) {
                    return (value!.isEmpty)
                        ? 'Enter the address for your building.'
                        : null;
                  }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: TextFormField(
                  controller: _numbOfAppController,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.assignment_rounded),
                    hintText: 'Enter the number of appartments',
                    labelText: 'Number of appartments',
                  ),
                  validator: (String? value) {
                    return (value!.isEmpty)
                        ? 'Enter the number of appartmentsin your building.'
                        : null;
                  }),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.2, right: 20),
                  child: FloatingActionButton(
                      backgroundColor: const Color(0xfff8a55f),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            RoleUtil.hasRole("Company")) {
                          var building = await addBuilding(
                              _addressController.text,
                              _numbOfAppController.text);
                          for (var i = 0;
                              i < int.parse(_numbOfAppController.text);
                              i++) {
                            await addAppartment(building, (i + 1));
                          }
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const BuildingView()));
                        }
                      },
                      child: const Icon(Icons.save)))
            ])
          ],
        ),
      ),
    );
  }
}

Future<int> addBuilding(addressController, numbOfAppController) async {
  var data = RoleUtil.getData();
  return await BuildingService(data)
      .addBuilding(addressController, numbOfAppController);
}

Future<Appartment> addAppartment(building, numbOfApps) async {
  return await AppartmentService().addAppartment(building, numbOfApps);
}
