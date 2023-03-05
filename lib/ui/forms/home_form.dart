import 'package:flutter/material.dart';

import '../../helper/role_util.dart';
import '../../models/person.dart';
import '../../models/report.dart';
import '../../models/report_status.dart';
import '../../services/person_service.dart';
import '../../services/report_service.dart';
import '../../services/report_status_service.dart';
import '../../ui/forms/report_add_form.dart';
import '../navigation_drawer/navigation_drawer.dart';
import 'report_view_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();
  String? filter = putFilter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      drawer: NavigationDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: 65,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FutureBuilder(
                future: getReportStatus(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.hasData
                      ? SizedBox(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(filter!)),
                            items: snapshot.data
                                .map<DropdownMenuItem<String>>((item) {
                              return DropdownMenuItem<String>(
                                value: item.statusDescription,
                                child: Text(item.statusDescription),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                filter = value;
                              });
                            },
                          ),
                        )
                      : const SizedBox(
                          child: Center(
                            child: Text('Loading...'),
                          ),
                        );
                },
              ),
            ),
          ),
          FutureBuilder<List<Report>>(
              future: fetchReports(filter),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PostCard(snapshot, index);
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const CircularProgressIndicator();
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: UniqueKey(),
          backgroundColor: const Color(0xfff8a55f),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ReportAdd()));
          },
          child: const Icon(Icons.add_outlined)),
    );
  }
}

class PostCard extends StatelessWidget {
  final AsyncSnapshot<List<Report>> snapshot;
  final int index;
  const PostCard(this.snapshot, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6 / 3,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {
            var report = snapshot.data![index];
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ReportView(report)));
          },
          child: Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: <Widget>[
                _Post(snapshot, index),
                const Divider(color: Colors.grey),
                _PostDetails(snapshot, index),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Post extends StatelessWidget {
  final AsyncSnapshot<List<Report>> snapshot;
  final int index;
  const _Post(this.snapshot, this.index);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(children: <Widget>[_PostTitleAndSummary(snapshot, index)]),
    );
  }
}

class _PostTitleAndSummary extends StatelessWidget {
  final AsyncSnapshot<List<Report>> snapshot;
  final int index;
  const _PostTitleAndSummary(this.snapshot, this.index, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleTheme = Theme.of(context).textTheme.headline6;
    final TextStyle? summaryTheme = Theme.of(context).textTheme.bodyText2;
    String title = snapshot.data![index].title;
    String summary = snapshot.data![index].description;

    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(title, style: titleTheme),
            const SizedBox(height: 2.0),
            Text(summary, style: summaryTheme),
          ],
        ),
      ),
    );
  }
}

class _PostDetails extends StatelessWidget {
  final AsyncSnapshot<List<Report>> lista;
  final int index;
  const _PostDetails(this.lista, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? nameTheme = Theme.of(context).textTheme.subtitle1;
    final int made = lista.data![index].madeBy;
    return FutureBuilder<Person>(
        future: fetchUserById(made),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: <Widget>[
                _UserNameAndEmail(lista, snapshot.data!.firstName,
                    snapshot.data!.lastName, nameTheme, index),
                _PostTimeStamp(lista, index),
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const CircularProgressIndicator();
        });
  }
}

class _UserNameAndEmail extends StatelessWidget {
  final AsyncSnapshot<List<Report>> snapshot;
  final int index;
  final String name;
  final String lastName;
  final TextStyle? nameTheme;
  const _UserNameAndEmail(
      this.snapshot, this.name, this.lastName, this.nameTheme, this.index,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("$name $lastName", style: nameTheme),
            const SizedBox(height: 2.0),
          ],
        ),
      ),
    );
  }
}

class _PostTimeStamp extends StatelessWidget {
  final AsyncSnapshot<List<Report>> snapshot;
  final int index;
  const _PostTimeStamp(this.snapshot, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? timeTheme = Theme.of(context).textTheme.caption;
    return Expanded(
      flex: 2,
      child:
          Text(snapshot.data![index].timeCreated.toString(), style: timeTheme),
    );
  }
}

Future<List<Report>> fetchReports(filter) async {
  var data = RoleUtil.getData();
  if (RoleUtil.hasRole("Company")) {
    return ReportService(data).getReportByCompany(data["companyId"], filter);
  } else {
    return ReportService(data).getReportByBuilding(data["buildingId"], filter);
  }
}

Future<Person> fetchUserById(int id) async {
  return PersonService.fetchUserById(id);
}

Future<List<ReportStatus>> getReportStatus() async {
  var data = RoleUtil.getData();
  return await ReportStatusService(data).getAllStatus();
}

String putFilter() {
  String filter;
  if (RoleUtil.hasRole("Representative")) {
    filter = "open";
  } else if (RoleUtil.hasRole("Company")) {
    filter = "accepted";
  } else {
    filter = "all";
  }

  return filter;
}
