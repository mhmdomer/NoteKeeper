import 'package:flutter/material.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:note_keeper/screens/details.dart';



class NoteList extends StatefulWidget {

  @override
  State<NoteList> createState() {
    return ListState();
  }
}

class ListState extends State<NoteList> {

  DatabaseHelper helper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if(noteList == null) {
      noteList = new List();
      _updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetails(Note('', '', 2),'New Note');
        },
        tooltip: 'Add Note',
        elevation: 10,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getNoteListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 3,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList[position].priority),
              child: Icon(Icons.keyboard_arrow_right),
            ),
            title: Text(noteList[position].title, style: titleStyle,),
            subtitle: Text(noteList[position].date),
            trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => confirmDelete(context, noteList[position].id),),
            onTap: () {
              navigateToDetails(noteList[position], 'Edit Note');
            },
          ),
        );
      },
    );

  }

  void navigateToDetails(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Details(note, title);
    }));
    if(result) {
      _updateListView();
    }
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  void delete(BuildContext context, int id) async {
    int result = await helper.deleteNote(id);
    if(result != 0) {
      _showSnack(context, 'Note Deleted successfully');
      _updateListView();
    }
  }

  void _showSnack(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(content: Text(message), duration: Duration(seconds: 1),);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _updateListView() async{
    var newList = await helper.getNoteList();
    setState(() {
     noteList = newList;
     count = noteList.length;
    });
  }

  void confirmDelete(BuildContext context, int id) {
    AlertDialog dialog = AlertDialog(
      content: Text('Are you sure you want to delete this note?'),
      title: Text('Delete'),
      actions: <Widget>[
        RaisedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Theme.of(context).primaryColorLight),),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
            delete(context, id);
          },
          child: Text('Delete', style: TextStyle(color: Theme.of(context).primaryColorLight)),
        ),
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }
}