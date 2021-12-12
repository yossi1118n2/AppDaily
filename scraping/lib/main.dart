import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart';

import 'package:universal_html/controller.dart';
// import 'package:universal_html/html.dart';
// import 'package:universal_html/indexed_db.dart';
// import 'package:universal_html/js.dart';
// import 'package:universal_html/js_util.dart';
// import 'package:universal_html/parsing.dart';
// import 'package:universal_html/svg.dart';
// import 'package:universal_html/web_audio.dart';
// import 'package:universal_html/web_gl.dart';


Future<void> main() async {

  // final controller = WindowController();
  // await controller.openHttp(
  //   method: 'GET',
  //   uri: Uri.parse('https://note.com/n2_blog/n/n4ef8a03f93a5'),
  // );
  // final document = controller.window!.document;
  // final topStorytitle = document.querySelectorAll("title").first.text;
  // print(topStorytitle);
  // final elements = document.querySelectorAll("h2");
  // for (final elem in elements) {
  //   print(elem.text);
  //   // print(elem.getAttribute("href"));
  // }
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
  late List<String> _element = [];
  late List<String> _url_list = [];
  final _controller = WindowController();

  String title = "--";
  String url_temp = "--";
  String note_url = "https://note.com";

  @override
  void initState(){
    _updatepage();
    super.initState();
  }

  Future<void> _updatepage() async {
    _element = [];
    _url_list = [];
    await _controller.openHttp(
      method: 'GET',
      uri: Uri.parse('https://note.com/n2_blog'),
    );
    final document = _controller.window!.document;
    final _topStorytitle = document.querySelectorAll("title").first.text;
    
    title = _topStorytitle ?? "--";
    print(_topStorytitle);
    final _elements = document.querySelectorAll("h3 > a");
    setState(() {
      for (final elem in _elements) {
        print(elem.text);
        print(elem.getAttribute("href"));
        url_temp = elem.getAttribute("href") as String;
        url_temp = note_url + url_temp;

        if(elem.text != null) {
          _element.add(elem.text as String);
          _url_list.add(url_temp);
        }else{
          _element.add("non-text");
          _url_list.add(note_url);
        }
      }
    });
  }

  // Future onLaunchUrl (String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   }
  // }
  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
          //後で指定する。
          itemCount: _element.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(_element[index]),
                  onTap: (){
                    //safariを開く
                    _launchURL(_url_list[index]);
                    print(_url_list[index]);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => Chatpage(name:titleList[index],uid: widget.user_id)));
                  },
                ),
                Divider(),
              ],
            );
          },

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _updatepage();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
