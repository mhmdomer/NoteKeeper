import 'package:flutter/material.dart';
import 'screens/note_list.dart';

void main() {
  runApp(MaterialApp(
    title: 'NoteKeeper',
//      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurple
//        primarySwatch: Colors.deepPurple,
      ),
      home: _MyApp()
    )
  );
}

class _MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return NoteList();

  }
}