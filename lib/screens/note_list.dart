import 'package:flutter/material.dart';

class NoteList extends StatefulWidget {

  @override
  State createState() {
    return ListState();
  }
}

class ListState extends State<NoteList> {

  int count = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes'),),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

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
          elevation: 1,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellowAccent,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            title: Text('Dummy title', style: titleStyle,),
            subtitle: Text('Dummy subtitle'),
            trailing: Icon(Icons.delete),
            onTap: () {
              //TODO
            },
          ),
        );
      },
    );

  }
}