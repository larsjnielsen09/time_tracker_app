class _HomeScreenState extends State<HomeScreen> {
  // ... (existing code)
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String customerName = '';
  DateTime date;
  int hoursUsed;
  String description = '';

  void _saveForm() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    print(customerName);
    print(date);
    print(hoursUsed);
    print(description);
    // Here, you can write code to save these to a database
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... (existing code)
      body: Column(
        // ... (existing code)
        child: Form(
          key: _formKey, // Assign the GlobalKey to the Form
          child: Column(
            // ... (existing code)
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a customer name';
                  }
                  return null;
                },
                onSaved: (value) {
                  customerName = value;
                },
              ),
              // ... (your other TextFormFields and validation logic)
            ],
          ),
        ),
      ),
      // ... (existing code)
      ElevatedButton(
        onPressed: _saveForm,  // Call _saveForm when the button is pressed
        child: Text('Submit'),
      ),
      // ... (existing code)
    );
  }
}
