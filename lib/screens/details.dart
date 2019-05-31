import 'package:flutter/material.dart';
import 'dart:async';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:intl/intl.dart';

class Details extends StatefulWidget {

  final String title;
  final Note note;
  Details(this.note, this.title);

  @override
  State createState() {
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
  TextEditingController descriptionController= TextEditingController();

  @override
  Widget build(BuildContext context) {

    TextStyle style = Theme.of(context).textTheme.subtitle;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          previousPage();
        }),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Column(
          children: <Widget>[
            Text('Priority:', style: style,),
            ListTile(
              title: DropdownButton(
                items: priorities.map((int value) {
                  return DropdownMenuItem(
                    child: Text(value == 1? 'High' : 'Low'),
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
              child: TextFormField(
                controller: titleController,
                style: style,
                onSaved: (String value) {
                  note.title = value;
                },
                validator: (value) => validate(value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  labelText: 'Title',
                  labelStyle: style,
                ),
              ),
            ),
            Expanded(
//              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: TextFormField(
//                  maxLines: 100,
//                  minLines: 20,
                  controller: descriptionController,
                  style: style,
                  onSaved: (String value) {
                    note.description = value;
                  },
                  validator: (String value) => validate(value),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    labelText: 'Description',
                    labelStyle: style,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text('Save', textScaleFactor: 1.2,),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      elevation: 4,
                      onPressed: () {
                        _save();
                      },
                    ),
                  ),
                  Container(width: 25,),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryColorLight,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: Text('Delete', textScaleFactor: 1.2,),
                      elevation: 4,
                      onPressed: () {
                        _delete();
                      },
                    ),
                  ),
                ],
              ),
            )
            )],
        ),
      )
    )
    );

  }

  void previousPage() {
    Navigator.pop(context, true);
  }

  void _save() async {
    if(_formKey.currentState.validate()){
      print('saving...');
      if(note.title.isEmpty || note.description.isEmpty) {
        _showSnack(context, 'Please fill all the fields');
        return;
      }
      previousPage();
      note.date = DateFormat.yMMMd().format(DateTime.now());
      int result;
      if(note.id == null) {
        result = await helper.insertNote(note);
      } else {
        result = await helper.updateNote(note);
      }
      if(result == 0) {
        _showDialog('Status', 'An error accured');
      }
    }
  }

  void _delete() async {
    previousPage();
    if(note.id == null) {
      return;
    } else {
      int result = await helper.deleteNote(note.id);
      if(result == 0) {
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
    SnackBar snackBar = SnackBar(content: Text(message), duration: Duration(seconds: 2),);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  validate(String value) {
    if(value.isEmpty){
      return 'please fill this field';
    }
  }
}