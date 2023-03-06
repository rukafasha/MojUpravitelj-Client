import 'package:flutter/material.dart';

import '../../helper/role_util.dart';
import '../../models/appartment.dart';
import '../../models/country.dart';
import '../../models/county.dart';
import '../../services/appartment_service.dart';
import '../../services/building_service.dart';
import '../../services/country_service.dart';
import '../../services/county_service.dart';
import '../../ui/forms/building_all_form.dart';

class BuildingAdd extends StatelessWidget {
  const BuildingAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BuildingAll()))),
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
  String? dropDownValueDrzava;
  String? dropDownValueOpstina;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                            ? 'Enter the number of appartments in your building.'
                            : null;
                      }),
                ),
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 20, left: MediaQuery.of(context).size.width / 4),
                    child: FutureBuilder(
                      future: getAllCountry(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return snapshot.hasData
                            ? Container(
                                child: DropdownButton<String>(
                                  hint: Text(dropDownValueDrzava ??
                                      "Make a selection"),
                                  items: snapshot.data
                                      .map<DropdownMenuItem<String>>((item) {
                                    return DropdownMenuItem<String>(
                                      value: item.countryName,
                                      child: Text(item.countryName),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      dropDownValueDrzava = value;
                                      dropDownValueOpstina = null;
                                    });
                                  },
                                ),
                              )
                            : Container(
                                child: const Center(
                                  child: Text('Loading...'),
                                ),
                              );
                      },
                    ),
                  ),
                ),
                if (dropDownValueDrzava != null)
                  SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 30, left: MediaQuery.of(context).size.width / 4),
                      child: FutureBuilder(
                        future: getAllCountyByCountry(dropDownValueDrzava),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return snapshot.hasData
                              ? Container(
                                  child: DropdownButton<String>(
                                    hint: Text(dropDownValueOpstina ??
                                        "Make a selection"),
                                    items: snapshot.data
                                        .map<DropdownMenuItem<String>>((item) {
                                      return DropdownMenuItem<String>(
                                        value: item.countyName,
                                        child: Text(item.countyName),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        dropDownValueOpstina = value;
                                      });
                                    },
                                  ),
                                )
                              : Container(
                                  child: const Center(
                                    child: Text('Loading...'),
                                  ),
                                );
                        },
                      ),
                    ),
                  ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 4,
                          right: 20),
                      child: FloatingActionButton(
                          backgroundColor: const Color(0xfff8a55f),
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                dropDownValueDrzava != null &&
                                dropDownValueOpstina != null &&
                                RoleUtil.hasRole("Company")) {
                              var building = await addBuilding(
                                  _addressController.text,
                                  _numbOfAppController.text,
                                  dropDownValueOpstina);
                              if (int.parse(_numbOfAppController.text) != 0) {
                                for (var i = 0;
                                    i < int.parse(_numbOfAppController.text);
                                    i++) {
                                  await addAppartment(building, (i + 1));
                                }
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const BuildingAll()));
                            }
                          },
                          child: const Icon(Icons.save)))
                ])
              ],
            ),
          ),
        ));
  }
}

Future<int> addBuilding(
    addressController, numbOfAppController, dropDownValueOpstina) async {
  var data = RoleUtil.getData();
  var opstina = await CountyService(data).getCountyByName(dropDownValueOpstina);
  return await BuildingService(data)
      .addBuilding(addressController, numbOfAppController, opstina);
}

Future<Appartment> addAppartment(building, numbOfApps) async {
  return await AppartmentService().addAppartment(building, numbOfApps);
}

Future<List<Country>> getAllCountry() async {
  var data = RoleUtil.getData;
  return await CountryService(data).getAllCountry();
}

Future<List<County>> getAllCountyByCountry(value) {
  var data = RoleUtil.getData;
  return CountyService(data).getCountyByCountry(value);
}
