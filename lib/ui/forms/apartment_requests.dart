import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../helper/global_url.dart';
import '../../helper/role_util.dart';
import '../../models/request_model.dart';
import '../../services/request_service.dart';
import '../../ui/forms/home_form.dart';

class ApartmentRequests extends StatefulWidget {
  const ApartmentRequests({super.key});

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
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomePage())),
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
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 15),
            color: Color.fromARGB(255, 231, 229, 229),
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color(0xfff1665f))),
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color(0xfff8a55f))),
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
  int ownerId,
  int tenantId,
  int appartmentId,
  int requestId,
  bool? approved,
  dynamic context,
) async {
  final response = await http.put(
    Uri.parse('${GlobalUrl.url}request/edit/$requestId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'ownerId': ownerId.toString(),
      'tenantId': tenantId.toString(),
      'appartmentId': appartmentId.toString(),
      'personId': appartmentId.toString(),
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
