import 'package:flutter/material.dart';

class Details extends StatefulWidget {

  String title;
  Details(this.title);

  @override
  State createState() {
    return DetailsState(title);
  }
}

class DetailsState extends State<Details> {

  String title;
  DetailsState(this.title);

  List<String> priorities = ['High', 'Low'];
  String priority;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController= TextEditingController();

  @override
  void initState() {
    super.initState();
    priority = priorities[0];
  }

  @override
  Widget build(BuildContext context) {

    TextStyle style = Theme.of(context).textTheme.subtitle;
    return WillPopScope(
      onWillPop: () {
        previousPage();
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          previousPage();
        }),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        child: ListView(
          children: <Widget>[
            Text('Priority:', style: style,),
            ListTile(
              title: DropdownButton(
                items: priorities.map((String value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                style: style,
                onChanged: (String value) {
                  setState(() {
                    priority = value;
                  });
                },
                value: priority,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                controller: titleController,
                style: style,
                onChanged: (String value) {

                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  labelText: 'Title',
                  labelStyle: style,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                controller: descriptionController,
                style: style,
                onChanged: (String value) {

                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  labelText: 'Description',
                  labelStyle: style,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
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

                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    )
    );

  }

  void previousPage() {
    Navigator.pop(context);
  }
}