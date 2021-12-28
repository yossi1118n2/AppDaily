import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(
    MultiProvider(
      // プロバイダ
      providers: [
        ChangeNotifierProvider(create: (_) => ClashProvider()),
      ],
      // アプリケーション
      child: MyApp(),
    )
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ArticleList(),
    );
  }
}


/// Wikipedia記事リスト
class ArticleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // API呼び出し
    context.read<ClashProvider>().init();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
      ),
      body: Center(
          child:Expanded(
            child: SizedBox(
            height: 200,
            child: Column(
              children: <Widget>[
                Consumer<ClashProvider>(
                  builder: (context, provider, child) {
                    return RefreshIndicator(
                      onRefresh: () => provider.init(),
                      child: ListView.builder(
                        itemCount: provider.items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(provider.items[index].name),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
      ),
      ),
    );
  }
}

/// Wikipediaプロバイダ
class ClashProvider extends ChangeNotifier {

  int _counter = 0;
  late Database database;
  late String path;

  List<Clan> items = [];


  // 記事リストを初期化する
  Future<void> init() async {
    // 記事リストをAPIから取得する
    items = await ClashApi().request();
    print('items');
    print(items[3].name);
    // リスナーに通知する
    notifyListeners();
  }

  Future<void> _makedatabase() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'demo.db');

    // open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Idea ('
                  'tag INTEGER PRIMARY KEY, '
                  'name TEXT, '
                  'trophy INTEGER, '
                  'isMember INTEGER, '
                  'contribution INTEGER, '
                  'medal1 INTEGER, '
                  'useddeck1 INTEGER, '
                  'season1 INTEGER, '
                  'week1 INTEGER, '
                  'medal2 INTEGER, '
                  'useddeck2 INTEGER, '
                  'season2 INTEGER, '
                  'week2 INTEGER, '
                  'medal3 INTEGER, '
                  'useddeck3 INTEGER, '
                  'season3 INTEGER, '
                  'week3 INTEGER, '
                  'medal4 INTEGER, '
                  'useddeck4 INTEGER, '
                  'season4 INTEGER, '
                  'week4 INTEGER, '
                  'medal5 INTEGER, '
                  'useddeck5 INTEGER, '
                  'season5 INTEGER, '
                  'week5 INTEGER, '
                  'totalmedal INTEGER, '
                  'donate1 INTEGER, '
                  'week1 INTEGER, '
                  'donate2 INTEGER, '
                  'week2 INTEGER, '
                  'donate3 INTEGER, '
                  'week3 INTEGER, '
                  'donate4 INTEGER, '
                  'week4 INTEGER, '
                  'totaldonate INTEGER, '
                  'position TEXT, '
                  'pastcontribution INTEGER'
                  ')');
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
          'INSERT INTO Idea(tag, name) VALUES(?, ?)',
          [111, 'フェリス']);
    });
    List<Map> list = await database.rawQuery('SELECT * FROM Idea');
    // setState(() {
    //   printlist = [];
    //   if(list.length == 0){
    //     PrintList printlist_temp = PrintList(title: _title, subTitle: _memo1, icon: Icons.add_a_photo , tileColor: Colors.redAccent);
    //     printlist.add(printlist_temp);
    //   }
    //   for(int i=0; i< list.length; i++){
    //     PrintList printlist_temp = PrintList(title: _title, subTitle: _memo1, icon: Icons.add_a_photo , tileColor: Colors.redAccent);
    //     printlist.add(printlist_temp);
    //   }
    // });

  }

}

/// Wikipediaの記事を取得するAPI
class ClashApi {
  String _token_in_kuresuto = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjllNjljNWU2LTZkMGItNDdmNS1iZTliLTQ2ZDk4YTZkNDZmMiIsImlhdCI6MTY0MDY5ODY5Nywic3ViIjoiZGV2ZWxvcGVyL2FmM2ExZTQ3LTI2OGQtNTI0Mi01ZjA3LTE5MmVjNWFlMTBhNyIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyI1OC4xNTcuMjAwLjExOSJdLCJ0eXBlIjoiY2xpZW50In1dfQ.taa2NOpaeKIzuoCN7Fr1CZbOw_OKz-8bNQOQLV1FPJofA87KML34RZF60rBF-LMlqm_VSwxKrN_o1tt9Zkm84Q';
  String _token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImY0N2FhYjM0LTZlYjYtNDA2Yy1iNzMxLWFhNDZlNDUwNGI0MyIsImlhdCI6MTY0MDM0NjI1MCwic3ViIjoiZGV2ZWxvcGVyL2FmM2ExZTQ3LTI2OGQtNTI0Mi01ZjA3LTE5MmVjNWFlMTBhNyIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyIxMzMuMTkuNy4xIl0sInR5cGUiOiJjbGllbnQifV19.D7dJ70SqJbsfAFWf10VAM7IAZWDzt9QXYzENRdA-avbgyWyk_njUQeWxj_GIDaFuaqbKf0N379j6dVoXmBRi9Q';
  String  _url = 'https://api.clashroyale.com/v1';



  static const _domain = 'ja.wikipedia.org';
  static const _path = '/w/api.php';
  // //ランダムに取得する場合
  // static const _params = {
  //   'format': 'json',
  //   'action': 'query',
  //   'list': 'random',
  //   'rnnamespace': '0',
  //   'rnlimit': '5',
  // };

  // static const _params = {
  //   'srsearch': '立命館大学',
  //   'format': 'json',
  //   'action': 'query',
  //   'list': 'search',
  //   'srnamespace': '0',
  //   'srlimit': '5',
  // };

  //とりあえず後でバグに対応
  // static const _headers = {
  //   "content-type": "application/json; charset=utf-8",
  //   "cache-control": "max-age=60",
  //   "authorization": "Bearer %s" % _token,
  // };

  // インスタンス
  static final ClashApi _instance = ClashApi._();

  // コンストラクタ
  ClashApi._();

  // ファクトリコンストラクタ(アロー関数はまだ慣れないので、書き換えた)
  // factory ClashApi() => _instance;
  factory ClashApi(){
    return _instance;
  }

  // リクエスト
  Future<List<Clan>> request() async {
    //uri.httpsでurlを作成する。
    String _endpoint = "https://api.clashroyale.com/v1/clans/%23LGVVQQJ2/members";
    // String _endpoint = _url + "/clans?name=#LGVVQQJ2";
    // var url = Uri.https(_domain, _path, _params);
    // print('url');
    // print(url);
    //なるほど、APIってURLを使って要素を指定するのか、よくわかった
    // http.Response response = await http.get(url);

    //http.Responseでheaderを使う方法がわからんなぁー
    // http.Response response = await http.get(url, headers: _headers);
    final response = await http.get(
      Uri.parse(_endpoint),
      // Send authorization headers to the backend.
      headers: {
        'Authorization' : 'Bearer ' + _token_in_kuresuto,
      },
    );

    // Map<String, String> requestHeaders = {
    //   'Content-type': 'application/json',
    //   'Accept': 'application/json',
    //   'Authorization': _token
    // };

    print('response');
    print(response);
    final responseJson = jsonDecode(response.body);


    print("responseJson");
    print(responseJson);

    var data = responseJson['items'] as List;
    print('data');
    print(data);
    return data.map((e) => Clan.fromJson(e)).toList();

    // print('response');
    // print(response);
    // //decodeする
    // var parsed = json.decode(response.body);
    // print('decoded');
    // print(parsed);
    // var data = parsed['query']['search'] as List;
    // //var data = parsed['search']['title'] as List;
    // print('data');
    // print(data);
    // return data.map((e) => WikipediaArticle.fromJson(e)).toList();
  }
}

class Clan {
  final String tag;
  final String name;

  Clan({
    required this.tag,
    required this.name,
  });

  factory Clan.fromJson(Map<String, dynamic> json) {
    return Clan(
      tag: json['tag'],
      name: json['name'],
    );
  }
}

// /// Wikipedia記事モデル
// class WikipediaArticle {
//   // ID
//   final int id;
//   // タイトル
//   String title;
//
//   // コンストラクタ(引数がidとtitleの時のコンストラクタ)
//   WikipediaArticle({required this.id, required this.title});
//
//   // コンストラクタ（JSON）(引数がMapの時のコンストラクタ)
//   WikipediaArticle.fromJson(Map<String, dynamic> json) :
//         this.id = json['pageid'] as int,
//         // this.id = json['id'] as int,
//         this.title = json['title'].toString();
// }
