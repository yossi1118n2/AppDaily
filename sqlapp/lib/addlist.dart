
import 'package:flutter/material.dart';

class addlist extends StatefulWidget {
  const addlist({Key? key}) : super(key: key);

  @override
  _addlistState createState() => _addlistState();
}

class _addlistState extends State<addlist> {

  List<DropdownMenuItem<int>> _items = [];
  int? _selectItem = 0;

  //スライダーの高さ
  int height = 180;

  @override
  void initState() {
    super.initState();
    setItems();
    _selectItem = _items[0].value;
  }

  void _saverecord(){
    //ここでデータを保存
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
              maxLength: 50,
              style: TextStyle(color: Colors.black),
              maxLines: 1,
              // onChanged:
            ),
            Text('ジャンルを選択'),
            DropdownButton(
              items: _items,
              value: _selectItem,
              onChanged: (value) => {
                setState(() {
                  _selectItem = value as int?;
                }),
              },
            ),
            Text('重要度'),
            Slider(
              value: height.toDouble(),
              min: 120,
              max: 220,
              onChanged: (double newValue) {
                setState(() {
                  height = newValue.round();
                });
              },
            ),
            Text('詳細メモ'),
            TextField(
              maxLength: 1000,
              style: TextStyle(color: Colors.black),
              maxLines: 1,
              // onChanged:
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saverecord,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
