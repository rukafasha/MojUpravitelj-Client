import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../background/background_app_bar.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _date = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static const fName = "Shakleen";
  static const lName = "Ishfar";
  static const uName = "Shakleen Ishfar";
  static const pass = "********";
  static const dob = "1996-06-12";

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    debugPrint('Second text field: ${firstNameController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundTop(),
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 550,
                  child: Stack(
                    children: [
                      Container(
                        height: 550,
                        margin: const EdgeInsets.only(right: 70),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: fName,
                                  icon: Icon(Icons.person),
                                  hintStyle: TextStyle(fontSize: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Color(0xfff8a55f)),
                                  ),
                                ),
                                controller: firstNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: lName,
                                  icon: Icon(Icons.person),
                                  hintStyle: TextStyle(fontSize: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Color(0xfff8a55f)),
                                  ),
                                ),
                                controller: lastNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintStyle: TextStyle(fontSize: 20),
                                  labelText: uName,
                                  icon: Icon(Icons.people),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Color(0xfff8a55f)),
                                  ),
                                ),
                                controller: usernameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: pass,
                                  icon: Icon(Icons.lock),
                                  hintStyle: TextStyle(fontSize: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Color(0xfff8a55f)),
                                  ),
                                ),
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextFormField(
                                  controller: _date,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please pick some date';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(fontSize: 16),
                                    border: InputBorder.none,
                                    icon: Icon(Icons.date_range),
                                    hintText: dob,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Color(0xfff8a55f)),
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2101));

                                    if (pickedDate != null) {
                                      setState(() {
                                        _date.text = DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                      });
                                    }
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xfff1665f),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Processing Data')),
                                    );
                                  }
                                },
                                child: const Text('Save'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
