import 'package:flutter/material.dart';
import 'package:praksa_frontend/Helper/RoleUtil.dart';
import 'package:praksa_frontend/Services/BuildingService.dart';
import 'package:praksa_frontend/ui/forms/buildingView_form.dart';

import '../../Models/Building.dart';
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
                height: MediaQuery.of(context).size.height/6,
              child: TextFormField( 
                controller: _descriptionController,
                expands: true,
                maxLines: null,
                minLines: null,
                  decoration: const InputDecoration(  
                   icon:  Icon(Icons.assignment_rounded),  
                    hintText: 'Enter an address',  
                    labelText: 'Address',  
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
                await DeleteBuilding(building);
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

    return await BuildingService(data).editBuilding(rep);
}

 Future DeleteBuilding(Building building) async {
  var data = RoleUtil.GetData();
    await BuildingService(data).buildingDelete(building);
 }