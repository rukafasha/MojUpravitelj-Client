import 'package:flutter/material.dart';

import '../../helper/role_util.dart';
import '../../models/appartment_person.dart';
import '../../ui/forms/home_form.dart';

class AddAppartmentPersonForm extends StatefulWidget {
  const AddAppartmentPersonForm({Key? key}) : super(key: key);

  @override
  State<AddAppartmentPersonForm> createState() => _AddAppartmentPersonForm();
}

class _AddAppartmentPersonForm extends State<AddAppartmentPersonForm> {
  late final AsyncSnapshot<List<AppartmentPerson>> snapshot;
  late final int index;

  static var data = RoleUtil.getData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                )),
        title: const Center(child: Text("Add Apartment")),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Color(0xfff8a55f), Color(0xfff1665f)]),
          ),
        ),
      ),
      body: null,
      // body: SingleChildScrollView(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: <Widget>[
      //       Expanded(
      //         child: Center(
      //           child: FutureBuilder<dynamic>(
      //               future: fetchAppartmentsByPerson(),
      //               builder: (context, snapshot) {
      //                 if (snapshot.connectionState == ConnectionState.waiting) {
      //                   return const CircularProgressIndicator();
      //                 } else if (snapshot.hasData &&
      //                     snapshot.data!.isNotEmpty) {
      //                   final apartments = snapshot.data!;
      //                   return buildApartment(apartments, context);
      //                 } else {
      //                   return const Text("Apartments not found.");
      //                 }
      //               }),
      //         ),
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: [
      //           Container(
      //             margin: const EdgeInsets.all(10),
      //             child: FloatingActionButton(
      //               heroTag: null,
      //               backgroundColor: const Color(0xfff8a55f),
      //               onPressed: () async {
      //                 // data = PersonService.getData();
      //                 // await PersonService.editPerson();
      //                 Navigator.of(context).push(MaterialPageRoute(
      //                     builder: (context) => const UserForm()));
      //               },
      //               child: const Icon(Icons.save),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

//   Widget buildApartment(List<dynamic> apartments, dynamic context) =>
//       ListView.builder(
//         shrinkWrap: true,
//         itemCount: apartments.length,
//         itemBuilder: (context, index) {
//           final apartment = apartments[index];
//           return Card(
//             child: ListTile(
//               title: Text("Apartman: ${apartment.appartmentId}"),
//             ),
//           );
//         },
//       );
}

// fetchApartments() async {
//   var data = RoleUtil.getData();
//   return AppartmentService(data).fetchApartments();
// }
