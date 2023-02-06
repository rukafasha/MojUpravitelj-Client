import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:praksa_frontend/Models/Building.dart';
import 'package:praksa_frontend/Models/Company.dart';
import 'package:http/http.dart' as http;
import 'package:praksa_frontend/Service/CompanyService.dart';

import '../../Helper/GlobalUrl.dart';
import 'package:praksa_frontend/Helper/RoleUtil.dart';

import 'buildingAdd_form.dart';
import 'home_form.dart';

class BuildingView extends StatelessWidget {
  const BuildingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                )),
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
      body: FutureBuilder<List<Building>>(
          future: fetchBuildings(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return PostCard(snapshot, index);
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
          heroTag: UniqueKey(),
          backgroundColor: const Color(0xfff8a55f),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BuildingAdd()));
          },
          child: const Icon(Icons.add_outlined)),
    );
  }
}

class PostCard extends StatelessWidget {
  final AsyncSnapshot<List<Building>> snapshot;
  final int index;
  const PostCard(this.snapshot, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6 / 3,
      child: Card(
        elevation: 2,
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
    );
  }
}

class _Post extends StatelessWidget {
  final AsyncSnapshot<List<Building>> snapshot;
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
  final AsyncSnapshot<List<Building>> snapshot;
  final int index;
  const _PostTitleAndSummary(this.snapshot, this.index, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleTheme = Theme.of(context).textTheme.headline6;
    final TextStyle? summaryTheme = Theme.of(context).textTheme.bodyText2;
    String title = snapshot.data![index].address;
    int summary = snapshot.data![index].numberOfAppartment;

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
            Text(summary.toString(), style: summaryTheme),
          ],
        ),
      ),
    );
  }
}

class _PostDetails extends StatelessWidget {
  final AsyncSnapshot<List<Building>> lista;
  final int index;
  const _PostDetails(this.lista, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? nameTheme = Theme.of(context).textTheme.subtitle1;
    final int made = lista.data![index].companyId;
    return FutureBuilder<Company>(
        future: fetchCompany(made),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: <Widget>[
                _UserNameAndEmail(lista, snapshot.data!.companyName, nameTheme, index),
                //_PostTimeStamp(lista, index),
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
  final AsyncSnapshot<List<Building>> snapshot;
  final int index;
  final String name;
  final TextStyle? nameTheme;
  const _UserNameAndEmail(
      this.snapshot, this.name,  this.nameTheme, this.index,
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
            Text(name, style: nameTheme),
            const SizedBox(height: 2.0),
          ],
        ),
      ),
    );
  }
}

Future<List<Building>> fetchBuildings() async{
  final http.Response response;
  var data = RoleUtil.GetData();
    var url = Uri.parse('${GlobalUrl.url}building/get/company/${data["companyId"]}');
    response = await http.get(url);

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((building) => Building.fromMap(building)).toList();
  } else {
    throw Exception('Unexpected error occured');
  }
}

Future<Company> fetchCompany(int id) async {
  var data = RoleUtil.GetData();
  return CompanyService(data).getCompanyById(id);
}
