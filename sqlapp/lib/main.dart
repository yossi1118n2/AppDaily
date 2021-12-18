import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:collection/collection.dart';

import 'addlist.dart';
import 'detail.dart';

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
  List<PrintList> printlist = [];

  int  _genre = 0;
  String _title = 'titleですよー';
  int _importance = 1;
  int _lastupdate = 0;
  int _status = 0;
  String _memo1 = 'memomemo';
  int _memo1update = 0;

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
      printlist = [];
      if(list.length == 0){
        PrintList printlist_temp = PrintList(title: _title, subTitle: _memo1, icon: Icons.add_a_photo , tileColor: Colors.redAccent);
        printlist.add(printlist_temp);
      }
      for(int i=0; i< list.length; i++){
        PrintList printlist_temp = PrintList(title: _title, subTitle: _memo1, icon: Icons.add_a_photo , tileColor: Colors.redAccent);
        printlist.add(printlist_temp);
      }
    });

  }

  void initprint(){
    PrintList printlist_temp = PrintList(title: _title, subTitle: _memo1, icon: Icons.add_a_photo , tileColor: Colors.redAccent);
    printlist.add(printlist_temp);
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
    List<Map> list = await database.rawQuery('SELECT * FROM Idea');
    // List<Map> expectedList = [
    //   {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
    //   {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
    // ];

    // print(expectedList);
    setState(() {
      printlist = [];
      if(list.length == 0){
        PrintList printlist_temp = PrintList(title: _title, subTitle: _memo1, icon: Icons.add_a_photo , tileColor: Colors.redAccent);
        printlist.add(printlist_temp);
      }
      for(int i=0; i< list.length; i++){
        _title = list[i]['title'];
        _memo1 = list[i]['memo1'];
        PrintList printlist_temp = PrintList(title: _title, subTitle: _memo1, icon: Icons.add_a_photo , tileColor: Colors.redAccent);
        printlist.add(printlist_temp);
      }
    });
    // setState(() {
    //   name_list = [];
    //   for(int i=0; i< list.length; i++){
    //     name_list.add(list[i]['name']);
    //   }
    // });
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
          children: <Widget>[
            // ElevatedButton(
            //   child: const Text('データベースにデータを挿入'),
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.red,
            //     onPrimary: Colors.black,
            //     shape: const StadiumBorder(),
            //   ),
            //   onPressed: () {
            //     _insertrecord();
            //   },
            // ),
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
                _getrecorde();
              },
            ),
            // Container(
            //   height: 300,
            //   child: ListView.builder(
            //     itemCount: name_list.length,
            //     itemBuilder: (context, index) {
            //       return Text(name_list[index]);
            //     },
            //   ),
            // )
            Container(
              height: 300,
              child: ListView.separated(
                padding: EdgeInsets.all(5),
                itemBuilder: (BuildContext context, int index) {
                  //ここを変える。
                  // var sub = state[index];
                  return SubListItem(
                    title: printlist[index].title,
                    subTitle: printlist[index].subTitle,
                    tileColor: printlist[index].tileColor,
                    leading: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: 44,
                            minWidth: 34,
                            maxHeight: 64,
                            maxWidth: 54),
                        child: Icon(printlist[index].icon)),

                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10);
                },
                itemCount: printlist.length,
              ),
            ),
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
        tooltip: 'Save',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SubListItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget leading;
  final Color tileColor;

  SubListItem({required this.title, required this.subTitle, required this.leading, required this.tileColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      leading: leading,
      onTap: () => {

      },
      onLongPress: () => {
        Navigator.push(context, MaterialPageRoute(
        // （2） 実際に表示するページ(ウィジェット)を指定する
        builder: (context) => detail(title: title)
        )),
      },
      trailing: Icon(Icons.more_vert),
    );
  }
}

class PrintList {
  //最終的に必要なやつ
  final String title;
  final String subTitle;
  final Color tileColor;
  final IconData icon;

  PrintList({required this.title, required this.subTitle, required this.icon, required this.tileColor});
}