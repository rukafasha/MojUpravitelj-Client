import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:praksa_frontend/ui/forms/home_form.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                )),
        title: const Center(child: Text("Moj upravitelj")),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Color(0xfff8a55f), Color(0xfff1665f)]),
          ),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: fName,
                      icon: Icon(Icons.person),
                      hintStyle: TextStyle(fontSize: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 3, color: Color(0xfff8a55f)),
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
                        borderSide:
                            BorderSide(width: 3, color: Color(0xfff8a55f)),
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
                        borderSide:
                            BorderSide(width: 3, color: Color(0xfff8a55f)),
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
                        borderSide:
                            BorderSide(width: 3, color: Color(0xfff8a55f)),
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
                          borderSide:
                              BorderSide(width: 3, color: Color(0xfff8a55f)),
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
                            _date.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          });
                        }
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xfff8a55f),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                        },
                        child: const Icon(Icons.save),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
