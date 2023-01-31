import 'package:flutter/material.dart';
import 'package:praksa_frontend/ui/forms/user_form.dart';

import '../forms/home_form.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

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
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Tenants'),
              onTap: () {},
            ),
          ],
        ),
      );
}
