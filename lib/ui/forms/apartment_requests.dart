import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:praksa_frontend/helper/role_util.dart';
import 'package:praksa_frontend/ui/forms/home_form.dart';
import 'package:http/http.dart' as http;
import '../../helper/global_url.dart';
import '../../models/request_model.dart';
import '../../services/request_service.dart';

class ApartmentRequests extends StatefulWidget {
  ApartmentRequests({super.key});

  @override
  State<ApartmentRequests> createState() => _ApartmentRequestsState();
}

class _ApartmentRequestsState extends State<ApartmentRequests> {
  late Future<List<RequestModel>> apartmentRequestsFuture;
  var _building_id, _person_id;

  @override
  void initState() {
    super.initState();

    apartmentRequestsFuture = getApartmentRequests();
  }

  Future<List<RequestModel>> getApartmentRequests() async {
    var data = RoleUtil.getData();

    return await RequestService(data).getApartmentRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: BackButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage())),
          ),
          title: const Text(
            "Requests",
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xfff8a55f), Color(0xfff1665f)]),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                    child: FutureBuilder<List<RequestModel>>(
                        future: apartmentRequestsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            final requests = snapshot.data!;
                            return buildRequests(requests, context);
                          } else {
                            return const Text("Requests not found.");
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget buildRequests(List<RequestModel> requests, dynamic context) =>
      ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];

          return Container(
            height: 135,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 15),
            color: Color.fromARGB(255, 195, 195, 195),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Name: ${request.firstName} ${request.lastName}")
                    ],
                  ),
                  Row(
                    children: [Text("Address: ${request.address}")],
                  ),
                  Row(
                    children: [Text("Apartment: ${request.appartmentId}")],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await declineOrAcceptTheRequest(
                            request.ownerId,
                            request.tenantId,
                            request.appartmentId,
                            request.requestId,
                            false,
                            context,
                          );
                        },
                        child: const Text('Decline'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await declineOrAcceptTheRequest(
                            request.ownerId,
                            request.tenantId,
                            request.appartmentId,
                            request.requestId,
                            true,
                            context,
                          );
                        },
                        child: const Text('Accept'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
}

Future declineOrAcceptTheRequest(
  int owner_id,
  int tenant_id,
  int appartment_id,
  int request_id,
  bool? approved,
  dynamic context,
) async {
  final response = await http.put(
    Uri.parse('${GlobalUrl.url}request/edit/$request_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'ownerId': owner_id.toString(),
      'tenantId': tenant_id.toString(),
      'appartmentId': appartment_id.toString(),
      'personId': appartment_id.toString(),
      'approved': approved,
    }),
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  } else {
    throw Exception('Failed!');
  }
}
