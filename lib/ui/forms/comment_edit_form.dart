import 'package:flutter/material.dart';

import '../../helper/role_util.dart';
import '../../models/comment.dart';
import '../../models/report.dart';
import '../../services/comment_service.dart';
import 'report_view_form.dart';

class CommentEdit extends StatelessWidget {
  final Comment comment;
  final Report report;
  const CommentEdit(this.report, this.comment, {super.key});

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
      body: CommentEditForm(comment, report),
    );
  }
}

class CommentEditForm extends StatefulWidget {
  final Comment comment;
  final Report report;
  const CommentEditForm(this.comment, this.report, {super.key});

  @override
  CommentEditFormState createState() {
    return CommentEditFormState(comment, report);
  }
}

class CommentEditFormState extends State<CommentEditForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final Comment comment;
  final Report report;
  CommentEditFormState(this.comment, this.report);
  @override
  Widget build(BuildContext context) {
    _descriptionController.text = comment.content;
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2.2,
                        right: 50),
                    child: FloatingActionButton(
                        backgroundColor: const Color(0xfff1665f),
                        heroTag: null,
                        onPressed: () async {
                          await commentDelete(comment);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReportView(report)));
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ))),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2.2,
                        right: 20),
                    child: FloatingActionButton(
                        backgroundColor: const Color(0xfff8a55f),
                        onPressed: () async {
                          await editComment(
                              comment, _descriptionController.text);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReportView(report)));
                        },
                        child: const Icon(Icons.save)))
              ])
            ],
          ),
        ),
      ),
    );
  }
}

Future<Comment> editComment(Comment c, string) async {
  var data = RoleUtil.getData();
  Comment comment = Comment(
    commentId: c.commentId,
    content: string,
    personId: c.personId,
    reportId: c.reportId,
  );
  return await CommentService(data).editComment(comment);
}

Future<void> commentDelete(Comment c) async {
  var data = RoleUtil.getData();
  await CommentService(data).deleteComment(c);
}
