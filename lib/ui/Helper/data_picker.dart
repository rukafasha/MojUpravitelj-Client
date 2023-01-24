import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key, required this.date}) : super(key: key);

  final date;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  // TextEditingController _date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DatePicker on TextField'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 16, right: 32),
        child: TextField(
            controller: widget.date,
            // obscureText: true,
            decoration: const InputDecoration(
              hintStyle: TextStyle(fontSize: 16),
              border: InputBorder.none,
              icon: Icon(Icons.date_range),
              hintText: "Select Date",
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101));

              if (pickedDate != null) {
                setState(() {
                  widget.date.text = DateFormat('yyyy-MM-dd')
                      .format(pickedDate); //set output date to TextField value.
                });
              }
            }),
      ),
    );
  }
}
