import 'package:flutter/material.dart';

import 'pages/home.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Searchable Dropdown',
      theme: ThemeData(
        primarySwatch: Colors.teal,        
      ),
      home: const HomePage(title: 'Searchable Dropdown'),
    );
  }
}
