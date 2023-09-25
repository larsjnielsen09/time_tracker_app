import 'package:flutter/material.dart';
//import 'add_entry_screen.dart';  // Import the AddEntryScreen class
import 'view_entries_screen.dart';  // Import the ViewEntriesScreen class
import 'dart:convert';
import 'package:http/http.dart' as http;



void main() {
  runApp(MyApp());
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/view': (context) => ViewEntriesScreen(),
      },
    );
  }
}

class _HomeScreenState extends State<HomeScreen>{

  DateTime selectedDate = DateTime.now();
  String? selectedHour = '1';
  String? kunde = '';
  DateTime? dato;
  int? timer;
  String? description = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

Future<void> insertData() async {
  final url = Uri.parse('https://service112.dk/api/api.php');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'kunde': kunde,
      'dato': dato?.toIso8601String(),
      'timer': timer,
      'description': description,
    }),
  );

  if (response.statusCode == 200) {
    print('Data inserted successfully');
  } else {
    print('Failed to insert data');
  }
}


  void _saveForm() async {
    
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    print(kunde);
    print(dato);
    print(timer);
    print(description);
    // Here, you can write code to save these to a database
     // Call insertData to post the form data to your API
  await insertData();  // Note: Awaiting the async function

  _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TimeTracker, by Lars Nielsen')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey, // Assign the GlobalKey to the Form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  TextFormField(
                    decoration: InputDecoration(labelText: 'Customer Name'),
                    onSaved: (value) {
                      if (value != null) {
                        kunde = value;
                      }
                  },
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                      return 'Please enter a customer name';
                      }
                      return null;
                  },
 
                  ),

                  TextFormField(
                  decoration: InputDecoration(labelText: 'Date'),
                    onSaved: (value) {
                      if (value != null) {
                       dato = DateTime.parse(value);
                      }
                    },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                  onTap: () {
                    _selectDate(context);  // Call the date picker function
                  },
                  readOnly: true, // This ensures the keyboard does not appear when you tap the field
                  controller: TextEditingController(
                    text: selectedDate.toLocal().toString().split(' ')[0] // Display the selected date
                  ),
                   ),


                  DropdownButtonFormField<String>(
                    value: selectedHour,
                    items: ['1', '2', '3', '4', '5', '6', '7'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedHour = newValue!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Hours Used'),
                      onSaved: (value) {
                      timer = int.tryParse(value ?? '');
                    },
                  ),

                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                      onSaved: (value) {
                        if (value != null) {
                          description = value;
                        }
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a description';
                        }
                        return null;
                      }, 
                  ),
                  
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/view');
                    },
                    child: Text('View Entries'),
                  ),
                  ElevatedButton(
                    onPressed: _saveForm,  // Call _saveForm when the button is pressed
                    child: Text('Submit'),
                  ),

 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
