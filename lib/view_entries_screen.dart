import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;




class ViewEntriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Entries')),
      body: Center(child: Text('This is the View Entries screen')),
    );
  }
}

