import 'package:flutter/material.dart';
import 'screens/note_list.dart';

void main() {
  runApp(_MyApp());
}

class _MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: NoteList(),
    );

  }
}