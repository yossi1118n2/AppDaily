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
    // Consumer
    return Consumer<WikipediaProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: () => provider.init(),
          child: ListView.builder(
            itemCount: provider.items.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                title: Text(provider.items[index].title),
              ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Wikipediaプロバイダ
class WikipediaProvider extends ChangeNotifier {

  // 記事リスト
  List<WikipediaArticle> items = [];

  // 記事リストを初期化する
  Future<void> init() async {
    // 記事リストをAPIから取得する
    items = await WikipediaApi().request();
    // リスナーに通知する
    notifyListeners();
  }
}

/// Wikipediaの記事を取得するAPI
class WikipediaApi {
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

  //
  static const _params = {
    'srsearch': '立命館大学',
    'format': 'json',
    'action': 'query',
    'list': 'search',
    'srnamespace': '0',
    'srlimit': '5',
  };

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
  Future<List<WikipediaArticle>> request() async {
    //uri.httpsでurlを作成する。
    var url = Uri.https(_domain, _path, _params);
    print('url');
    print(url);
    //なるほど、APIってURLを使って要素を指定するのか、よくわかった
    http.Response response = await http.get(url);

    print('response');
    print(response);
    //decodeする
    var parsed = json.decode(response.body);
    print('decoded');
    print(parsed);
    var data = parsed['query']['search'] as List;
    //var data = parsed['search']['title'] as List;
    print('data');
    print(data);
    return data.map((e) => WikipediaArticle.fromJson(e)).toList();
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
