class Note {

  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title, this._description, this._priority, [this._date]);
  Note.withId(this._id, this._title, this._description, this._priority, [this._date]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;

  set title(String title) {
    if(title.isNotEmpty || title.length < 200) {
      this._title = title;
    }
  }

  set description(String description) {
    if(description.isNotEmpty) {
      this._description = description;
    }
  }

  set priority(int priority) {
    if(priority == 1 || priority == 2) {
      this._priority = priority;
    }
  }

  set date(String date) {
    this._date = date;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['description'] = description;
    map['priority'] = priority;
    map['date'] = date;
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    title = map['title'];
    description = map['description'];
    date = map['date'];
    priority = map['priority'];
  }

}