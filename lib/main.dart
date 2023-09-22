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
  String selectedHour = '1';

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Customer Name'),
                  ),
                  TextFormField(
                  decoration: InputDecoration(labelText: 'Date'),
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
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Hours Used'), 
                    keyboardType: TextInputType.number,
                  ),

                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
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
                    onPressed: () {
                      // Handle form submission
                    },
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
