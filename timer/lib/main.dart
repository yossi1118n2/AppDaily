import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Stopwatch s = Stopwatch();
  //音を出すためのインスタンス
  final _audio = AudioCache();
  String display = '00:00';

  @override
  void initState() {
    Timer.periodic(
      Duration(seconds: 1),
      _onTimer,
    );
    super.initState();
  }

  int second = 0;
  int minuts = 0;

  void _onTimer(Timer timer) {
    _updatetime();
  }


  void _updatetime() {
    print(s.elapsedMilliseconds);
    setState(() {
      second = (s.elapsedMilliseconds / 1000).toInt() % 60;
      minuts = (s.elapsedMilliseconds / 60000).toInt();
      display = '${minuts}:${second}';
      print("updata");
    });
  }

  void _start(){
    s.start();
  }

  void _stop(){
    s.stop();
  }

  void _reset(){
    s.reset();
  }


  @override
  Widget build(BuildContext context) {

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(display, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 50),),
            Row(
              children: [
                Icon(
                  Icons.notifications,
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("This is the title"),
                          content: Text("This is the content"),
                          actions: [
                            FlatButton(
                              child: Text("Cancel"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                              child: Text("OK"),
                              onPressed: () => print('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  // タッチ検出対象のWidget
                  child: Text(
                    '${_counter}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(30),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notifications,
                    ),
                    Icon(
                      Icons.notifications,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                ),
                Text("ベル2"),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(30),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notifications,
                    ),
                    Icon(
                      Icons.notifications,
                    ),
                    Icon(
                      Icons.notifications,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                ),
                Text("ベル3"),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(60),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  child: s.isRunning ? Text('一時停止') : Text('スタート'),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(),
                  ),
                  onPressed: () {
                    if(s.isRunning == true) {
                        _stop();
                    }else{
                        _start();
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                ),
                OutlinedButton(
                  child: const Icon(
                    Icons.notifications,
                  ),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(),
                  ),
                  onPressed: () async {
                    _audio.play('bell.mp3');
                    await Future.delayed(Duration(milliseconds: 500));
                    _audio.play('bell.mp3');
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                ),
                OutlinedButton(
                  child: const Text('リセット'),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(),
                  ),
                  onPressed: () {
                    _reset();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
