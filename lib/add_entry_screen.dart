TextFormField(
    decoration: InputDecoration(labelText: 'Customer Name'),
    onSaved: (value) {
        if (value != null) {
        customerName = value;
        }
    },
    validator: (value) {
        if (value?.isEmpty ?? true) {
        return 'Please enter a customer name';
        }
        return null;
    },
),
