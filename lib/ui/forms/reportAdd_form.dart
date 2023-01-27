import 'package:flutter/material.dart';
import 'package:praksa_frontend/ui/forms/home_form.dart';

import '../NavigationDrawer/navigation_drawer.dart';

class ReportAdd extends StatelessWidget {
  const ReportAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
        body: AddForm(),
        drawer: const NavigationDrawer(),
        floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0xfff8a55f),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const HomePage()));},
              child: Icon(Icons.keyboard_arrow_left, size: 40,)
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat
      );
  }
}
class AddForm extends StatefulWidget {  
  @override  
  AddFormState createState() {  
    return AddFormState();  
  } 
}


class AddFormState extends State<AddForm> {  
  // Create a global key that uniquely identifies the Form widget  
  // and allows validation of the form.  
  final _formKey = GlobalKey<FormState>();  
  
  @override  
  Widget build(BuildContext context) {  
    // Build a Form widget using the _formKey created above.  
    return Form(  
      key: _formKey,  
      child: Column(  
        crossAxisAlignment: CrossAxisAlignment.start,  
        children: <Widget>[  
          TextFormField(  
            decoration: const InputDecoration(  
              icon: const Icon(Icons.short_text),  
              hintText: 'Enter title for report',  
              labelText: 'Title',  
            ), 
            validator: (String? value) {
              return (value!.isEmpty) ? 'Enter the title of your report.' : null; 
            }
          ),  
          SizedBox(
            height: 150,
          child: TextFormField(  
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
            mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
            padding: new EdgeInsets.only(top: 20),
            child: FloatingActionButton(
            backgroundColor: Color(0xfff8a55f),
            onPressed: () {
              if(_formKey.currentState!.validate()){
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const HomePage()));};
            },
            child: Icon(Icons.save)
          ))])
        ],  
      ),
    );  
  }  
}  