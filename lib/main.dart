import 'package:flutter/material.dart';
import 'screens/note_list.dart';
import 'screens/details.dart';

void main() {
  runApp(_MyApp());
}

class _MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'NoteKeeper',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: NoteList(),
    );

  }
}