import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:praksa_frontend/helper/role_util.dart';
import 'package:praksa_frontend/ui/forms/appartment_person_add_form.dart';
import 'package:praksa_frontend/ui/forms/home_form.dart';

import '../../models/appartment_person.dart';
import '../../services/appartment_person_service.dart';
import '../../services/person_service.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  static final _myBox = Hive.box("myBox");
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  late final AsyncSnapshot<List<AppartmentPerson>> snapshot;
  late final int index;

  bool _customTileExpanded = false;

  static var data = RoleUtil.getData();
  static const uName = "Shakleen Ishfar";
  static const companyId = '1';

  void saveDataToLocalStorage(data) async {
    _myBox.put(1, {
      "firstName": data["firstName"],
      "lastName": data["lastName"],
      "DOB": data["DOB"],
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    debugPrint('Second text field: ${firstNameController.text}');
  }

  @override
  Widget build(BuildContext context) {
    firstNameController.text = data["firstName"];
    lastNameController.text = data["lastName"];
    dataController.text = data["DOB"];
    usernameController.text = "Shakleen Ishfar";
    companyController.text = "1";

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                )),
        title: const Center(child: Text("Moj upravitelj")),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Color(0xfff8a55f), Color(0xfff1665f)]),
          ),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: data["firstName"],
                        icon: const Icon(Icons.person),
                        hintStyle: const TextStyle(fontSize: 20),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 3, color: Color(0xfff8a55f)),
                        ),
                      ),
                      controller: firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: data["lastName"],
                        icon: const Icon(Icons.person),
                        hintStyle: const TextStyle(fontSize: 20),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 3, color: Color(0xfff8a55f)),
                        ),
                      ),
                      controller: lastNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(fontSize: 20),
                        labelText: uName,
                        icon: Icon(Icons.account_circle_rounded),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 3, color: Color(0xfff8a55f)),
                        ),
                      ),
                      controller: usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(fontSize: 20),
                        labelText: companyId,
                        icon: Icon(Icons.business),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 3, color: Color(0xfff8a55f)),
                        ),
                      ),
                      controller: companyController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                        controller: dataController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please pick some date';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(fontSize: 16),
                          border: InputBorder.none,
                          icon: const Icon(Icons.date_range),
                          hintText: data["DOB"].toString(),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xfff8a55f)),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            setState(() {
                              dataController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        }),
                  ),
                  ExpansionTile(
                    title: const Text('Show apartments'),
                    trailing: Icon(
                      _customTileExpanded
                          ? Icons.arrow_drop_down_circle
                          : Icons.arrow_drop_down,
                    ),
                    children: <Widget>[
                      Center(
                        child: FutureBuilder<dynamic>(
                            future: fetchAppartmentsByPerson(),
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
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: FloatingActionButton(
                              heroTag: null,
                              backgroundColor: const Color(0xfff8a55f),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const AddAppartmentPersonForm()));
                              },
                              child: const Icon(Icons.add_outlined),
                            ),
                          ),
                        ],
                      ),
                    ],
                    onExpansionChanged: (bool expanded) {
                      setState(() => _customTileExpanded = expanded);
                    },
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
                            if (_formKey.currentState!.validate()) {
                              data = PersonService.getData(
                                  firstNameController.text,
                                  lastNameController.text,
                                  usernameController.text,
                                  passwordController.text,
                                  dataController.text);
                              await PersonService.editPerson(
                                  firstNameController.text,
                                  lastNameController.text,
                                  usernameController.text,
                                  passwordController.text,
                                  dataController.text);
                              saveDataToLocalStorage(data);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                            }
                          },
                          child: const Icon(Icons.save),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildApartments(List<dynamic> apartments, dynamic context) =>
      ListView.builder(
        shrinkWrap: true,
        itemCount: apartments.length,
        itemBuilder: (context, index) {
          final apartment = apartments[index];

          return Card(
            child: ListTile(
              title: Text("Apartman: ${apartment.appartmentId}"),
            ),
          );
        },
      );
}

fetchAppartmentsByPerson() async {
  var data = RoleUtil.getData();
  return AppartmentPersonService(data).fetchAppartmentsByPerson();
}
