import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';

void main() => runApp(
    MultiProvider(
      // プロバイダ
      providers: [
        ChangeNotifierProvider(create: (_) => WikipediaProvider()),
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
    context.read<WikipediaProvider>().init();
    return Scaffold(body:Container());
    // Consumer
    // return Consumer<WikipediaProvider>(
    //   builder: (context, provider, child) {
    //     return RefreshIndicator(
    //       onRefresh: () => provider.init(),
    //       child: ListView.builder(
    //         itemCount: provider.items.length,
    //         itemBuilder: (context, index) {
    //           return Card(
    //             child: ListTile(
    //             title: Text(provider.items[index].title),
    //           ),
    //           );
    //         },
    //       ),
    //     );
    //   },
    // );
  }
}

/// Wikipediaプロバイダ
class WikipediaProvider extends ChangeNotifier {


  // 記事リストを初期化する
  Future<void> init() async {
    // 記事リストをAPIから取得する
    Clan items = await WikipediaApi().request();
    // リスナーに通知する
    notifyListeners();
  }
}

/// Wikipediaの記事を取得するAPI
class WikipediaApi {

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

  static const _params = {
    'srsearch': '立命館大学',
    'format': 'json',
    'action': 'query',
    'list': 'search',
    'srnamespace': '0',
    'srlimit': '5',
  };

  //とりあえず後でバグに対応
  // static const _headers = {
  //   "content-type": "application/json; charset=utf-8",
  //   "cache-control": "max-age=60",
  //   "authorization": "Bearer %s" % _token,
  // };

  // インスタンス
  static final WikipediaApi _instance = WikipediaApi._();

  // コンストラクタ
  WikipediaApi._();

  // ファクトリコンストラクタ(アロー関数はまだ慣れないので、書き換えた)
  // factory WikipediaApi() => _instance;
  factory WikipediaApi(){
    return _instance;
  }

  // リクエスト
  Future<Clan> request() async {
    //uri.httpsでurlを作成する。
    String _endpoint = "https://api.clashroyale.com/v1/cards?limit=10";
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
        'Authorization' : 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImY0N2FhYjM0LTZlYjYtNDA2Yy1iNzMxLWFhNDZlNDUwNGI0MyIsImlhdCI6MTY0MDM0NjI1MCwic3ViIjoiZGV2ZWxvcGVyL2FmM2ExZTQ3LTI2OGQtNTI0Mi01ZjA3LTE5MmVjNWFlMTBhNyIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyIxMzMuMTkuNy4xIl0sInR5cGUiOiJjbGllbnQifV19.D7dJ70SqJbsfAFWf10VAM7IAZWDzt9QXYzENRdA-avbgyWyk_njUQeWxj_GIDaFuaqbKf0N379j6dVoXmBRi9Q',
        // 'Authorization: Bearer API_TOKEN'
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        // 'TOKEN': _token
      },
      // {
      //   // 'DESCRIPTION': 'use macbook',
      //   // 'TOKEN': _token,
      //   HttpHeaders.authorizationHeader: requestHeaders,
      //   // HttpHeaders.
      //   // HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
      // },
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
    return Clan.fromJson(responseJson);

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
  final int id;
  final String name;

  Clan({
    required this.id,
    required this.name,
  });

  factory Clan.fromJson(Map<String, dynamic> json) {
    return Clan(
      id: json['id'],
      name: json['name'],
    );
  }
}

/// Wikipedia記事モデル
class WikipediaArticle {
  // ID
  final int id;
  // タイトル
  String title;

  // コンストラクタ(引数がidとtitleの時のコンストラクタ)
  WikipediaArticle({required this.id, required this.title});

  // コンストラクタ（JSON）(引数がMapの時のコンストラクタ)
  WikipediaArticle.fromJson(Map<String, dynamic> json) :
        this.id = json['pageid'] as int,
        // this.id = json['id'] as int,
        this.title = json['title'].toString();
}
