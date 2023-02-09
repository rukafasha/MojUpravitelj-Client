import 'package:flutter/material.dart';
import 'package:praksa_frontend/Helper/RoleUtil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:praksa_frontend/ui/forms/login_form.dart';
import 'package:praksa_frontend/ui/forms/myReports_form.dart';
import 'package:praksa_frontend/ui/forms/user_form.dart';

import '../forms/buildingAll_form.dart';
import '../forms/home_form.dart';

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({super.key});

  final _myBox = Hive.box("myBox");

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container();

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 5,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home Page'),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage())),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const UserForm()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_rounded),
              title: const Text('My reports'),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MyReport()));
              },
            ),
            Visibility(
              visible: RoleUtil.HasRole("Company"),
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Buildings'),
                onTap: () {Navigator.pop(context);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const BuildingAll()));},
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _myBox.clear();
                RoleUtil.DeleteDataFromBox();

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginForm()));
              },
            ),
           
          ],
        ),
      );
}
