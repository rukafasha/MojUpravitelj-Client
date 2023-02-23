import 'package:flutter/material.dart';

import '../../helper/role_util.dart';
import '../../models/comment.dart';
import '../../models/report.dart';
import '../../services/comment_service.dart';
import 'report_view_form.dart';

class CommentAdd extends StatelessWidget {
  final Report report;
  const CommentAdd(this.report, {super.key});

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
      body: AddForm(report),
    );
  }
}

class AddForm extends StatefulWidget {
  final Report report;
  const AddForm(this.report, {super.key});

  @override
  AddFormState createState() {
    return AddFormState(report);
  }
}

class AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final Report report;
  AddFormState(this.report);
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
              height: MediaQuery.of(context).size.height / 6,
              child: TextFormField(
                  controller: _descriptionController,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.assignment_rounded),
                    hintText: 'Enter the content',
                    labelText: 'Content',
                  ),
                  validator: (String? value) {
                    return (value!.isEmpty)
                        ? 'Enter the content of your comment.'
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
                        await addComment(
                            report.id, _descriptionController.text);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ReportView(report)));
                      },
                      child: const Icon(Icons.save)))
            ])
          ],
        ),
      ),
    );
  }
}

Future<Comment> addComment(report, string) async {
  var data = RoleUtil.getData();
  Comment comment = Comment(
    commentId: 0,
    content: string,
    personId: data["personId"],
    reportId: report,
  );
  return await CommentService(data).addComment(comment);
}
