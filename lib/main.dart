import 'package:flutter/material.dart';
//import 'add_entry_screen.dart';  // Import the AddEntryScreen class
import 'view_entries_screen.dart';  // Import the ViewEntriesScreen class

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
  String? customerName = '';
  DateTime? date;
  int? hoursUsed;
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

  void _saveForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    print(customerName);
    print(date);
    print(hoursUsed);
    print(description);
    // Here, you can write code to save these to a database
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TimeTracker')),
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
                      customerName = value;
                    },
                  ),
                  TextFormField(
                  decoration: InputDecoration(labelText: 'Date'),
                    onSaved: (value) {
                      if (value != null) {
                       date = DateTime.parse(value);
                      }
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
                    items: ['1', '2', '3', '4', '5'].map((String value) {
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
                      hoursUsed = int.tryParse(value ?? '');
                    },
                  ),

                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                      onSaved: (value) {
                      description = value;
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
