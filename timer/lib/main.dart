import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_picker/flutter_picker.dart';

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
      home: MyHomePage(title: 'プレゼンタイマー'),
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
  Stopwatch s = Stopwatch();
  //音を出すためのインスタンス
  final _audio = AudioCache();
  String display = '00:00';

  late DateTime _datetime;
  @override
  void initState() {
    Timer.periodic(
      Duration(seconds: 1),
      _onTimer,
    );
    _datetime = DateTime.utc(0, 0, 0);
    print(_datetime);
    super.initState();
  }

  int second = 0;
  int minutes = 0;

  int second1 = 0;
  int minutes1 = 0;

  int second2 = 0;
  int minutes2 = 0;

  int second3 = 0;
  int minutes3 = 0;


  void _onTimer(Timer timer) {
    _updatetime();
  }


  Future<void> _updatetime() async {
    print(s.elapsedMilliseconds);
    setState(() {
      second = (s.elapsedMilliseconds / 1000).toInt() % 60;
      minutes = (s.elapsedMilliseconds / 60000).toInt();
      print("updata");
    });

    if(second == 0 && minutes == 0){
      print('skip');
    }else if(second1 == second && minutes1 == minutes){
      _audio.play('bell.mp3');
    }else if(second2 == second && minutes2 == minutes){
      _audio.play('bell.mp3');
      await Future.delayed(Duration(milliseconds: 500));
      _audio.play('bell.mp3');
    }else if(second3 == second && minutes3 == minutes){
      _audio.play('bell.mp3');
      await Future.delayed(Duration(milliseconds: 500));
      _audio.play('bell.mp3');
      await Future.delayed(Duration(milliseconds: 500));
      _audio.play('bell.mp3');
    }
  }

  void _start(){
    s.start();
  }

  void _stop(){
    s.stop();
  }

  void _reset(){
    s.reset();
    s.stop();
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
            Row(

              children: [
                Padding(
                  padding: EdgeInsets.all(30),
                ),
                Text('${minutes.toString().padLeft(2, '0')}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 80),),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text(':', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 80),),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text('${second.toString().padLeft(2, '0')}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 80),),
                Padding(
                  padding: EdgeInsets.all(20),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(50),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications,
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                ),
                GestureDetector(
                  onTap: () async {
                    Picker(
                      adapter: DateTimePickerAdapter(type: PickerDateTimeType.kHMS, value: _datetime, customColumnType: [3, 4, 5]),
                      title: Text("Select Time"),
                      onConfirm: (Picker picker, List value) {
                        setState(() => {
                        _datetime = DateTime.utc(0, 0, 0, value[0], value[1], value[2])});
                        minutes1 = value[1];
                        second1 = value[2];
                      },
                    ).showModal(context);
                  },
                  // タッチ検出対象のWidget
                  child: Row(
                    children: [
                      Text(
                        '${minutes1.toString().padLeft(2, '0')}:${second1.toString().padLeft(2, '0')}',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                GestureDetector(
                  onTap: () async {
                    Picker(
                      adapter: DateTimePickerAdapter(type: PickerDateTimeType.kHMS, value: _datetime, customColumnType: [3, 4, 5]),
                      title: Text("Select Time"),
                      onConfirm: (Picker picker, List value) {
                        setState(() => {
                        _datetime = DateTime.utc(0, 0, 0, value[0], value[1], value[2])});
                        minutes2 = value[1];
                        second2 = value[2];
                      },
                    ).showModal(context);
                  },
                  // タッチ検出対象のWidget
                  child: Text(
                    '${minutes2.toString().padLeft(2, '0')}:${second2.toString().padLeft(2, '0')}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                GestureDetector(
                  onTap: () async {
                    Picker(
                      adapter: DateTimePickerAdapter(type: PickerDateTimeType.kHMS, value: _datetime, customColumnType: [3, 4, 5]),
                      title: Text("Select Time"),
                      onConfirm: (Picker picker, List value) {
                        setState(() => {
                        _datetime = DateTime.utc(0, 0, 0, value[0], value[1], value[2])});
                        minutes3 = value[1];
                        second3 = value[2];
                      },
                    ).showModal(context);
                  },
                  // タッチ検出対象のWidget
                  child: Text(
                    '${minutes3.toString().padLeft(2, '0')}:${second3.toString().padLeft(2, '0')}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(30),
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




