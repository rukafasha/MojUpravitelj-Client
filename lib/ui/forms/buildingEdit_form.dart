
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:praksa_frontend/Helper/RoleUtil.dart';
import 'package:praksa_frontend/Models/Report.dart';
import 'package:praksa_frontend/ui/forms/buildingView_form.dart';
import 'package:praksa_frontend/ui/forms/home_form.dart';
import 'package:praksa_frontend/ui/forms/reportView_form.dart';

import '../../Helper/GlobalUrl.dart';
import '../../Models/Building.dart';
import '../../Service/ReportService.dart';
import 'buildingAll_form.dart';


class BuildingEdit extends StatelessWidget {
  final Building building;
  const BuildingEdit(this.building, {super.key});

  @override
  Widget build(BuildContext context) {
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
        body: EditForm(building),
    );
  }
  
}
class EditForm extends StatefulWidget {
  final Building building;
  const EditForm(this.building, {super.key});
  
  @override  
  EditFormState createState() {  
    return EditFormState(building);  
  } 
}


class EditFormState extends State<EditForm> {   
  final _formKey = GlobalKey<FormState>();  
  final TextEditingController _descriptionController = TextEditingController();
  Building building;
  EditFormState(this.building);
  
  @override  
  Widget build(BuildContext context) { 
    _descriptionController.text = building.address;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Form(  
        key: _formKey,  
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[    
            SizedBox(
              height: MediaQuery.of(context).size.height/6,
            child: TextFormField( 
              controller: _descriptionController,
              expands: true,
              maxLines: null,
              minLines: null,
                decoration: const InputDecoration(  
                 icon:  Icon(Icons.assignment_rounded),  
                  hintText: 'Enter a description',  
                  labelText: 'Description',  
                ),
              validator: (String? value) {
                return (value!.isEmpty) ? 'Enter the description of your report.' : null; 
              } 
            ),), 
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.2, right: 50),
              child: FloatingActionButton(
              backgroundColor: const Color(0xfff1665f),
              heroTag: null,
              onPressed: () async {
              await buildingDelete(building);
              Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BuildingAll()));
        },
              child: const Icon(Icons.delete, color: Colors.black,)
            )),
              Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.2, left: 50),
              child: FloatingActionButton(
              heroTag: null,
              backgroundColor: const Color(0xfff8a55f),
              onPressed: () async {
                if(_formKey.currentState!.validate()){
                  building =  await EditBuilding( _descriptionController.text, building);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>  BuildingView(building)));}
              },
              child: const Icon(Icons.save)
            ))])
          ],  
        ),
      ),
    );  
  }  
}  


Future<Building> EditBuilding(descriptionController, r) async {
    var data = RoleUtil.GetData();
    Building building = r;
    Building rep = Building(
      buildingId: building.buildingId,
      address: descriptionController.toString(),
      companyId: building.companyId,
      numberOfAppartment: building.numberOfAppartment,
      countyId: building.countyId,
      representativeId: building.representativeId
    );

    final response = await http.put(
      Uri.parse('${GlobalUrl.url}building/edit/${building.buildingId}'),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String,dynamic>{
        'address': rep.address.toString(),
        'companyId':rep.companyId.toString(),
        'numberOfAppartment': rep.numberOfAppartment.toString(),
        'countyId': rep.countyId.toString(),
        'representativeId': rep.representativeId,
      }),
    );
   if (response.statusCode == 200) {
    return Building.fromJson(response.body);
  } else {
    throw Exception('Building loading failed!');
  }
}

 Future buildingDelete(Building building) async {
    var data = RoleUtil.GetData();
    final http.Response response = await http.delete(
      Uri.parse('${GlobalUrl.url}building/delete/${building.buildingId}'),
    );
 }