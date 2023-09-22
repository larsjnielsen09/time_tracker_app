// ... (rest of your code)

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

// ... (rest of your code)
