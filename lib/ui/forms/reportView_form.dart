import 'package:flutter/material.dart';
import 'package:praksa_frontend/Helper/RoleUtil.dart';
import 'package:praksa_frontend/Models/Comment.dart';
import 'package:praksa_frontend/Models/Report.dart';
import 'package:praksa_frontend/Services/ReportService.dart';
import 'package:praksa_frontend/Services/ReportStatusService.dart';
import 'package:praksa_frontend/ui/forms/commentEdit_form.dart';
import 'package:praksa_frontend/ui/forms/reportEdit_form.dart';
import '../../Models/Person.dart';
import '../../Services/CommentService.dart';
import '../../Services/PersonService.dart';
import 'commentAdd_form.dart';
import 'home_form.dart';

class ReportView extends StatefulWidget{
  final Report report;
  const ReportView(this.report, {super.key});

  @override
  State<ReportView> createState() => _ReportViewState(report);
}

class _ReportViewState extends State<ReportView> {
  final Report report;
  _ReportViewState(this.report);
  String? status;
  @override
  void initState() {
  getStatus(report.status).then((value) => status = value);
    super.initState();
  }
  Widget build(BuildContext context) { 
   var data = RoleUtil.GetData();
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const HomePage()))),
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<Person>(
                future: fetchUsers(report.madeBy),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                  return Column(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[Color(0xfff8a55f),Color(0xfff1665f)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [0.5, 0.9],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              report.title,
                              style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${snapshot.data!.firstName} ${snapshot.data!.lastName}" ,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                color: const Color(0xfff1665f),
                                child:ListTile(
                                  title: const Text(
                                    "Created at: ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${report.timeCreated.day}.${report.timeCreated.month}.${report.timeCreated.year}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if(report.timeFinished == null)
                            Expanded(
                              child: Container(
                                color: const Color(0xfff8a55f),
                                child: const ListTile(
                                  title: Text(
                                    "Closed at: ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Report is not closed",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if(report.timeFinished != null)
                            Expanded(
                              child: Container(
                                color: const Color(0xfff8a55f),
                                child: ListTile(
                                  title: const Text(
                                    "Closed at: ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${report.timeCreated.day}.${report.timeCreated.month}.${report.timeCreated.year}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if((RoleUtil.HasRole("Representative") || RoleUtil.HasRole("Company") && status != "closed"))
                       Container(
                      height: 65,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: FutureBuilder(
                          future:getReportStatus(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            return snapshot.hasData
                                ? Container(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text(status!),
                                      items: snapshot.data.map<DropdownMenuItem<String>>((item) {
                                        return DropdownMenuItem<String>(
                                          value: item.statusDescription,
                                          child: Text(item.statusDescription),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          status = value!;
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
                      
                               ListTile(
                                  subtitle: Text(
                                    report.description,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                           Expanded(
               child: FutureBuilder<List<Comment>>(
                    future: getListOfComments(report.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        final comments = snapshot.data!;
                        return buildComments(comments, context, report);
                      } else {
                         return const Text("Comments not found.");
                      }
                    }),
             
           ),
                    ],
                  );
                  }else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const CircularProgressIndicator();
                }
              ),
            ),
           
             
                
          ],
        ),
        floatingActionButton: 
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Visibility(
                    visible: RoleUtil.HasRole("Representative") || RoleUtil.HasRole("Company") || report.madeBy == data["personId"],
                      child:  Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FloatingActionButton(
                            heroTag: null,
                            backgroundColor: const Color(0xfff8a55f),
                            onPressed: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => CommentAdd(report)));},
                            child: const Icon(Icons.comment)
                          ),
                        ),
                      )
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [ 
                Visibility(
                    visible: (RoleUtil.HasRole("Representative") || RoleUtil.HasRole("Company")) && report.status != 2,
                      child:  Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: FloatingActionButton(
                          heroTag: null,
                          backgroundColor: const Color(0xfff8a55f),
                          onPressed: () async {
                            var report2 = await updateReport(report, status);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ReportView(report2)));},
                          child: const Icon(Icons.save)
                        ),
                      )
                ),
                Visibility(
                  visible: report.madeBy == data["personId"] && report.status == 1,
                    child:  FloatingActionButton(
                      heroTag: null,
                      backgroundColor: const Color(0xfff8a55f),
                      onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ReportEdit(report)));},
                      child: const Icon(Icons.edit)
                    )
                ),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


Future<Person> fetchUsers(int id) async {
  return await PersonService.fetchUserById(id);
}

Future<String> getStatus(id)async {
  var data = RoleUtil.GetData();
  return await ReportStatusService(data).getStatusById(id);
}

Future<Report> updateReport(Report report, String? status) async {
  var data = RoleUtil.GetData();
  return await ReportService(data).changeReportStatus(report, status);
}

Future<List<Comment>> getListOfComments(int reportId)async{
  var data = RoleUtil.GetData();
  return await CommentService(data).getCommentsByReportId(reportId);
}

Future<String> fetchUsersName(int id) async {
  return PersonService.fetchUsersName(id);
}
Widget buildComments(List<Comment> comments, dynamic context, Report report) =>
      ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          var data = RoleUtil.GetData();
          final comment = comments[index];
          final person =  fetchUsersName(comment.personId);
          return FutureBuilder<String>(
                future: fetchUsersName(comment.personId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData &&
                      snapshot.data!.isNotEmpty) {
                    return InkWell(
                      onTap: () {
                        if(comment.personId == data["personId"]){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => CommentEdit(report, comment)));
                        }
                      },
                        child: Card(
                          child: ListTile(
                            title: Text("Comment: ${comment.content}"),
                            subtitle: Text("User: ${snapshot.data}"),
                          ),
                        ),
                      );
                  } else {
                     return const Text("Comments not found.");
                  }
                });
        }
      );