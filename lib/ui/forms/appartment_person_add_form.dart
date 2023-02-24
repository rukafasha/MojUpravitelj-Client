import 'package:flutter/material.dart';

import 'package:praksa_frontend/Helper/RoleUtil.dart';
import 'package:praksa_frontend/ui/forms/home_form.dart';

import '../../Models/AppartmentPerson.dart';

class AddAppartmentPersonForm extends StatefulWidget {
  const AddAppartmentPersonForm({Key? key}) : super(key: key);

  @override
  State<AddAppartmentPersonForm> createState() => _AddAppartmentPersonForm();
}

class _AddAppartmentPersonForm extends State<AddAppartmentPersonForm> {
  late final AsyncSnapshot<List<AppartmentPerson>> snapshot;
  late final int index;

  static var data = RoleUtil.GetData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()),
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
      
    );
  }
}