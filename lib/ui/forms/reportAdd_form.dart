
import 'package:flutter/material.dart';
import 'package:praksa_frontend/Helper/RoleUtil.dart';
import 'package:praksa_frontend/Models/Report.dart';
import 'package:praksa_frontend/ui/forms/home_form.dart';

import '../../Services/ReportService.dart';

class ReportAdd extends StatelessWidget {
  const ReportAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomePage()))),
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
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  controller: _titleController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.short_text),
                    hintText: 'Enter title for report',
                    labelText: 'Title',
                  ),
                  validator: (String? value) {
                    return (value!.isEmpty)
                        ? 'Enter the title of your report.'
                        : null;
                  }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: TextFormField(
                  controller: _descriptionController,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.assignment_rounded),
                    hintText: 'Enter a description',
                    labelText: 'Description',
                  ),
                  validator: (String? value) {
                    return (value!.isEmpty)
                        ? 'Enter the description of your report.'
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
                            RoleUtil.HasRole("Tenant")) {
                          await AddReport(_titleController.text,
                              _descriptionController.text);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomePage()));
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

Future<Report> AddReport(titleController, descriptionController) async {
  var data = RoleUtil.GetData();
  Report report = Report(
    id: 1,
    title: titleController,
    description: descriptionController,
    timeCreated: DateTime.now(),
    timeFinished: null,
    madeBy: data["personId"],
    closedBy: null,
    status: 1,
  );
  return await ReportService(data).addReport(report);
}
