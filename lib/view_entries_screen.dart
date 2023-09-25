import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ViewEntriesScreen extends StatefulWidget {
  @override
  _ViewEntriesScreenState createState() => _ViewEntriesScreenState();
}

class _ViewEntriesScreenState extends State<ViewEntriesScreen> {
  List<Map<String, dynamic>> _tasks = [];  // Define _tasks here
  

  @override
  void initState() {
    super.initState();
    _loadMoreTasks();  // Fetch initial data when the widget is created
  }

Future<bool> deleteTask(int taskId) async {
  final String apiUrl = 'https://service112.dk/api/api.php';
  
  // Construct the request payload
  final Map<String, dynamic> payload = {'id': taskId};
  
  // Send the DELETE request
  final response = await http.delete(
    Uri.parse(apiUrl),
    body: json.encode(payload),
    headers: {
      "Content-Type": "application/json",
    },
  );

  // Parse the response
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseBody = json.decode(response.body);
    if (responseBody['status'] == 'success') {
      return true;
    } else {
      print('Error deleting task: ${responseBody['message']}');
      return false;
    }
  } else {
    print('Error deleting task with status code: ${response.statusCode}');
    return false;
  }
}



Future<List<Map<String, dynamic>>> fetchData({int page = 1, int limit = 5}) async {
  try {
    final response = await http.get(Uri.parse('https://service112.dk/api/api.php?page=$page&limit=$limit'));

    //print('API Response Code: ${response.statusCode}');  // Debugging line
    //print('API Response Body: ${response.body}');  // Debugging line

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      //print('Decoded response: $decodedResponse');  // Debugging line

      if (decodedResponse['status'] == 'success' && decodedResponse.containsKey('tasks')) {
        return List<Map<String, dynamic>>.from(decodedResponse['tasks']);
      } else {
        throw Exception('Failed to load data: ${decodedResponse['message']}');
      }
    } else {
      throw Exception('Failed to load data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception caught: $e');
    throw Exception('Failed to load data');
  }
}

int currentPage = 1;  // Initialize the current page to 1

void _loadMoreTasks() {
  //print('Next page to load: $currentPage');  // Debugging line
  fetchData(page: currentPage, limit: 5).then((newTasks) {
    setState(() {
      _tasks.addAll(newTasks);
      currentPage++;  // Increment the current page after successfully fetching data
    });
  }).catchError((error) {
    print('Error loading more tasks: $error');
  });
}


@override

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('View Entries'),
    ),
    body: _tasks.isEmpty // Check if _tasks is empty
        ? FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchData(), // Only fetch data on initial load
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                _tasks.addAll(snapshot.data!); // Add the fetched data to _tasks
                return _buildListView(); // Build list view from _tasks
              }
            },
          )
        : _buildListView(), // If _tasks is not empty, build list view from it
  );
}

Widget _buildListView() {
  return ListView.builder(
    itemCount: _tasks.length + 1,
    itemBuilder: (BuildContext context, int index) {
      if (index == _tasks.length) {
        return ElevatedButton(
          onPressed: _loadMoreTasks, // This function will be called when the 'Load More' button is pressed
          child: Text('Load More'),
        );
      }
      return ListTile(
        title: Text(_tasks[index]['kunde'] ?? 'Unknown'), // Changed snapshot.data to _tasks
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${_tasks[index]['dato'] ?? 'Unknown'}'), // Changed snapshot.data to _tasks
            Text('Hours: ${_tasks[index]['timer'] ?? 'Unknown'}'), // Changed snapshot.data to _tasks
            Text('Description: ${_tasks[index]['description'] ?? 'No description'}'), // Changed snapshot.data to _tasks
          ],
        ),

        trailing: ElevatedButton(
          onPressed: () async {
            int taskId = int.parse(_tasks[index]['id']);
            bool result = await deleteTask(taskId);
            if (result) {
              setState(() {
                _tasks.removeAt(index);
              });
            }
          },
          child: Text('Delete'),
        ),

      );
    },
  );
}

}