import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:collection/collection.dart';

import 'addlist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late Database database;
  late String path;
  List<String> name_list = ['--'];
  // Get a location using getDatabasesPath

  @override
  void initState() {
    super.initState();
    print("initState");

    _makedatabase();
  }
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      _insertrecord();
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

  Future<void> _insertrecord() async {
    int  _genre = 0;
    String _title = 'titleですよー';
    int _importance = 1;
    int _lastupdate = 0;
    int _status = 0;
    String _memo1 = 'memomemo';
    int _memo1update = 0;



    // Insert some records in a transaction
    await database.transaction((txn) async {
      // int id1 = await txn.rawInsert(
      //     'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
      // print('inserted1: $id1');
      int id = await txn.rawInsert(
          // 'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
          // ['another name', 12345678, 3.1416]);
          'INSERT INTO Idea(genre, title, importance, lastupdate, status, memo1, memo1update, memo2, memo2update, memo3, memo3update, memo4, memo4update) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [_genre, '${_title}', _importance, _lastupdate, _status, _memo1, _memo1update, 'null', 0, 'null', 0, 'null', 0]);
      print('inserted2: $id');
    });
    List<Map> list = await database.rawQuery('SELECT * FROM Idea');
    setState(() {
      name_list = [];
      for(int i=0; i< list.length; i++){
        name_list.add(list[i]['title']);
      }
    });

  }

  // Future<void> _updatarecord() async {
  //   // Update some record
  //
  //   // int count = await database.rawUpdate(
  //   //     'UPDATE Test SET name = ?, value = ? WHERE name = ?',
  //   //     ['updated name', '9876', 'some name']);
  //   // print('updated: $count');
  //   // List<Map> list = await database.rawQuery('SELECT * FROM Test');
  //
  //   int count = await database.rawUpdate(
  //       'UPDATE Idea SET name = ?, value = ? WHERE name = ?',
  //       ['updated name', '9876', 'some name']);
  //   print('updated: $count');
  //   List<Map> list = await database.rawQuery('SELECT * FROM Idea');
  //
  //   setState(() {
  //     name_list = [];
  //     for(int i=0; i< list.length; i++){
  //       name_list.add(list[i]['name']);
  //     }
  //   });
  // }

  void _getrecorde() async{
    // Get the records
    List<Map> list = await database.rawQuery('SELECT * FROM Test');
    // List<Map> expectedList = [
    //   {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
    //   {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
    // ];

    // print(expectedList);

    setState(() {
      name_list = [];
      for(int i=0; i< list.length; i++){
        name_list.add(list[i]['name']);
      }
    });
    //assert(const DeepCollectionEquality().equals(list, expectedList));
  }

  Future<void> _delete() async {
    // Delete a record
    deleteDatabase(path);
  }





  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              child: const Text('データベースにデータを挿入'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.black,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                _insertrecord();
              },
            ),
            ElevatedButton(
              child: const Text('データベースをリセット'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.black,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                _delete();
                _makedatabase();
              },
            ),
            ElevatedButton(
              child: const Text('データベースを更新'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.black,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                // _updatarecord();
              },
            ),
            Container(
              height: 300,
              child: ListView.builder(
                itemCount: name_list.length,
                itemBuilder: (context, index) {
                  return Text(name_list[index]);
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // （1） 指定した画面に遷移する
          Navigator.push(context, MaterialPageRoute(
            // （2） 実際に表示するページ(ウィジェット)を指定する
              builder: (context) => addlist()
          ));
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
