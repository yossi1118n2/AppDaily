
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class addlist extends StatefulWidget {
  const addlist({Key? key}) : super(key: key);

  @override
  _addlistState createState() => _addlistState();
}

class _addlistState extends State<addlist> {
  late Database database;
  late String path;

  //データベースに挿入するための変数
  int  _genre = 0;
  String _title = 'titleですよー';
  int _importance = 1;
  int _lastupdate = 0;
  int _status = 0;
  String _memo1 = 'memomemo';
  int _memo1update = 0;

  List<DropdownMenuItem<int>> _items = [];
  int? _selectItem = 0;

  @override
  void initState() {
    super.initState();
    setItems();
    _selectItem = _items[0].value;
    _makedatabase();
  }

  Future<void> _makedatabase() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'demo.db');

    // open the database
    database = await openDatabase(path, version: 1,
        // onCreate: (Database db, int version) async {
        //   // When creating the db, create the table
        //   await db.execute(
        //       'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
        // });
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Idea (id INTEGER PRIMARY KEY, genre INTEGER, title TEXT, importance INTEGER, lastupdate INTEGER, status INTEGER, memo1 TEXT, memo1update TEXT, memo2 TEXT, memo2update TEXT, memo3 TEXT, memo3update TEXT, memo4 TEXT, memo4update TEXT)');
        });
  }

  Future<void> _insertrecord() async {

    // Insert some records in a transaction
    await database.transaction((txn) async {
      // int id1 = await txn.rawInsert(
      //     'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
      // print('inserted1: $id1');
      int id = await txn.rawInsert(
        // 'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
        // ['another name', 12345678, 3.1416]);
          'INSERT INTO Idea(genre, title, importance, lastupdate, status, memo1, memo1update, memo2, memo2update, memo3, memo3update, memo4, memo4update) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [_genre, '${_title}', _importance, 0, _status, _memo1, 0, 'null', 0, 'null', 0, 'null', 0]);
      print('inserted2: $id');
    });
  }


  void setItems() {
    _items
      ..add(DropdownMenuItem(
        child: Text('ジャンルなし', style: TextStyle(fontSize: 40.0),),
        value: 1,
      ))
      ..add(DropdownMenuItem(
        child: Text('研究関連', style: TextStyle(fontSize: 40.0),),
        value: 2,
      ))
      ..add(DropdownMenuItem(
        child: Text('趣味関連', style: TextStyle(fontSize: 40.0),),
        value: 3,
      ))
      ..add(DropdownMenuItem(
        child: Text('スポーツ関連', style: TextStyle(fontSize: 40.0),),
        value: 4,
      ));
  }

  String text = '--';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('新しいリストを追加'),
    ),
        body: Column(
          children: [
            Text('titleを入力'),
            TextField(
              decoration: InputDecoration(
                hintText: 'タイトル',
              ),
              maxLength: 50,
              style: TextStyle(color: Colors.black),
              maxLines: 1,
              autofocus: true,
              onChanged:(text){
                _title = text;
              }
            ),
            Text('ジャンルを選択'),
            DropdownButton(
              items: _items,
              value: _selectItem,
              onChanged: (value) => {
                setState(() {
                  _selectItem = value as int?;
                  _genre = _selectItem ?? 0;
                }),
              },
            ),
            Text('重要度'),
            Slider(
              value: 1,
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (double value) {
                setState(() {
                  _importance = value.toInt();
                });
              },
            ),
            Text('詳細メモ'),
            TextField(
              maxLength: 1000,
              style: TextStyle(color: Colors.black),
              maxLines: 1,
              onChanged:(text){
                _memo1 = text;
              }
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _insertrecord,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
