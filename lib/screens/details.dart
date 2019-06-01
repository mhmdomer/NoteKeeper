import 'package:flutter/material.dart';

//import 'dart:async';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:intl/intl.dart';

class Details extends StatefulWidget {
  final String title;
  final Note note;

  Details(this.note, this.title);

  @override
  State<Details> createState() {
    return DetailsState(note, title);
  }
}

class DetailsState extends State<Details> {
  String title;
  Note note;

  DetailsState(this.note, this.title);

  DatabaseHelper helper = DatabaseHelper();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  List<int> priorities = [1, 2];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.subhead;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.delete), onPressed: () => confirmDelete()),
            FlatButton(
                onPressed: () => _save(),
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(top: 15, left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Priority:',
                      style: style,
                    ),
                  ),
                  ListTile(
                    title: DropdownButton(
                      items: priorities.map((int value) {
                        return DropdownMenuItem(
                          child: Text(value == 1 ? 'High' : 'Low'),
                          value: value,
                        );
                      }).toList(),
                      style: style,
                      onChanged: (value) {
                        setState(() {
                          note.priority = value;
                        });
                      },
                      value: note.priority,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: TextField(
                      controller: titleController,
                      style: style,
                      onChanged: (String value) {
                        note.title = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4)),
                        labelText: 'Title',
                        alignLabelWithHint: true,
                        labelStyle: style,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 11,
//                      minLines: 20,
                        controller: descriptionController,
                        style: style,
                        onChanged: (String value) {
                          note.description = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4)),
                          labelText: 'Content',
                          alignLabelWithHint: true,
                          labelStyle: style,
                        ),
                      ),
                    ),
                ],
              ),
            )));
  }

  void previousPage() {
    Navigator.pop(context, true);
  }

  void _save() async {
    print('saving...');
    if (note.title.isEmpty || note.description.isEmpty) {
      _showSnack(context, 'Please fill all the fields');
      return;
    }
    previousPage();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id == null) {
      result = await helper.insertNote(note);
    } else {
      result = await helper.updateNote(note);
    }
    if (result == 0) {
      _showDialog('Status', 'An error accured');
    }
  }

  void _delete() async {
    previousPage();
    if (note.id == null) {
      return;
    } else {
      int result = await helper.deleteNote(note.id);
      if (result == 0) {
        _showDialog('Status', 'An error accured');
      } else {
        _showSnack(context, 'Note Deleted Successfully');
      }
    }
  }

  void _showDialog(String title, String message) {
    AlertDialog dialog = AlertDialog(
      content: Text(message),
      title: Text(title),
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  void _showSnack(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  validate(String value) {
    if (value.isEmpty) {
      return 'please fill this field';
    }
  }

  void confirmDelete() {
    AlertDialog dialog = AlertDialog(
      content: Text('Are you sure you want to delete this note?'),
      title: Text('Delete'),
      actions: <Widget>[
        RaisedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).primaryColorLight),
          ),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
            _delete();
          },
          child: Text('Delete',
              style: TextStyle(color: Theme.of(context).primaryColorLight)),
        ),
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }
}
