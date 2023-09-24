import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ViewEntriesScreen extends StatelessWidget {

  // Future<List<Map<String, dynamic>>> fetchData() async {
  //   final response = await http.get(Uri.parse('https://service112.dk/api/api.php'));

  //   if (response.statusCode == 200) {
  //     return List<Map<String, dynamic>>.from(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

    Future<List<Map<String, dynamic>>> fetchData() async {
  final response = await http.get(Uri.parse('https://service112.dk/api/api.php'));

  if (response.statusCode == 200) {
    Map<String, dynamic> decodedResponse = json.decode(response.body);
    if (decodedResponse['status'] == 'success') {
      return List<Map<String, dynamic>>.from(decodedResponse['tasks']);
    } else {
      throw Exception('Failed to load tasks');
    }
  } else {
    throw Exception('Failed to load data');
  }
}


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Entries'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data?[index]['kunde'] ?? 'Unknown'),
                  subtitle: Text(snapshot.data?[index]['description'] ?? 'No description'),

                  // Add more fields here
                );
              },
            );
          }
        },
      ),
    );
  }
}