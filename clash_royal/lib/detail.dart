import 'package:clash_royal/main.dart';
import 'package:flutter/material.dart';

class detail extends StatefulWidget {
  detail({Key? key, required Clan this.items}) : super(key: key);

  Clan items;

  @override
  _detailState createState() => _detailState();
}

class _detailState extends State<detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('詳細'),
      ),
      body:ListView(
        children: <Widget>[
          Text(widget.items.tag),
          Text(widget.items.name),
          Text(widget.items.trophy.toString()),
          Text(widget.items.role),
        ],
      )
    );
  }
}
