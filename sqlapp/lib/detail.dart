
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class detail extends StatefulWidget {
  detail({Key? key, required this.title}) : super(key: key);
  String? title;
  @override
  _detailState createState() => _detailState();
}

class _detailState extends State<detail> {
  List<double> opacityLevel = [0,0,0];
  String _memo1 = '---';
  String _memo2 = '---';
  String _memo3 = '---';

  late Database database;
  late String path;
  List<String> name_list = ['--'];

  @override
  void initState() {
    super.initState();
    print("initState_detail");

    _makedatabase();
  }

  void _toggle(int index){
    setState(() {
      if(opacityLevel[index] == 0){
        opacityLevel[index] = 1;
      }else{
        opacityLevel[index] = 0;
      }
    });
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

  //まだ書き換えていない。
  Future<void> _updatarecord() async {
    // Update some record

    // int count = await database.rawUpdate(
    //     'UPDATE Test SET name = ?, value = ? WHERE name = ?',
    //     ['updated name', '9876', 'some name']);
    // print('updated: $count');
    // List<Map> list = await database.rawQuery('SELECT * FROM Test');

    int count = await database.rawUpdate(
        'UPDATE Idea SET name = ?, value = ? WHERE name = ?',
        ['updated name', '9876', 'some name']);
    print('updated: $count');
    List<Map> list = await database.rawQuery('SELECT * FROM Idea');

    setState(() {
      name_list = [];
      for(int i=0; i< list.length; i++){
        name_list.add(list[i]['name']);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title ?? 'non-title'),
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // シングルタップ時に呼ばれる
                _toggle(0);
              },
              // タッチ検出対象のWidget
              child: Text(
                'データベースからメモを入れる',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            AnimatedOpacity(
              opacity: opacityLevel[0],
              duration: const Duration(seconds: 3),
              child: TextField(
                  maxLength: 1000,
                  style: TextStyle(color: Colors.black),
                  maxLines: 1,
                  onChanged:(text){
                    _memo1 = text;
                  }
              ),
            ),
            GestureDetector(
              onTap: () {
                // シングルタップ時に呼ばれる
                _toggle(1);
              },
              // タッチ検出対象のWidget
              child: Text(
                'データベースからメモを入れる',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            AnimatedOpacity(
              opacity: opacityLevel[1],
              duration: const Duration(seconds: 3),
              child: TextField(
                  maxLength: 1000,
                  style: TextStyle(color: Colors.black),
                  maxLines: 1,
                  onChanged:(text){
                    _memo1 = text;
                  }
              ),
            ),
            GestureDetector(
              onTap: () {
                // シングルタップ時に呼ばれる
                _toggle(2);
              },
              // タッチ検出対象のWidget
              child: Text(
                'データベースからメモを入れる',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            AnimatedOpacity(
              opacity: opacityLevel[2],
              duration: const Duration(seconds: 3),
              child: TextField(
                  maxLength: 1000,
                  style: TextStyle(color: Colors.black),
                  maxLines: 1,
                  onChanged:(text){
                    _memo1 = text;
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
