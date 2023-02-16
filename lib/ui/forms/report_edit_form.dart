import 'package:flutter/material.dart';
import 'package:praksa_frontend/helper/role_util.dart';
import 'package:praksa_frontend/models/report.dart';
import 'package:praksa_frontend/ui/forms/home_form.dart';
import 'package:praksa_frontend/ui/forms/report_view_form.dart';

import '../../services/report_service.dart';

class ReportEdit extends StatelessWidget {
  final Report report;
  const ReportEdit(this.report, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ReportView(report)))),
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
      body: EditForm(report),
    );
  }
}

class EditForm extends StatefulWidget {
  final Report report;
  const EditForm(this.report, {super.key});

  @override
  EditFormState createState() {
    return EditFormState(report);
  }
}

class EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Report report;
  EditFormState(this.report);

  @override
  Widget build(BuildContext context) {
    _descriptionController.text = report.description;
    _titleController.text = report.title;
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.2, right: 50),
                  child: FloatingActionButton(
                      backgroundColor: const Color(0xfff1665f),
                      heroTag: null,
                      onPressed: () async {
                        await ReportDelete(report);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomePage()));
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      ))),
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.2, left: 50),
                  child: FloatingActionButton(
                      heroTag: null,
                      backgroundColor: const Color(0xfff8a55f),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            RoleUtil.hasRole("Tenant")) {
                          report = await EditReport(_titleController.text,
                              _descriptionController.text, report);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReportView(report)));
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

Future<Report> EditReport(titleController, descriptionController, r) async {
  var data = RoleUtil.getData();
  Report report = r;
  Report rep = Report(
    id: report.id,
    title: titleController,
    description: descriptionController,
    timeCreated: report.timeCreated,
    timeFinished: report.timeFinished,
    madeBy: report.madeBy,
    closedBy: report.closedBy,
    status: report.status,
  );
  return await ReportService(data).editReport(rep);
}

Future ReportDelete(Report report) async {
  var data = RoleUtil.getData();
  await ReportService(data).deleteReport(report);
}
