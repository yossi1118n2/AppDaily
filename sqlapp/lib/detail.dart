
import 'package:flutter/material.dart';

class detail extends StatefulWidget {
  detail({Key? key, required String title}) : super(key: key);
  String? title;
  @override
  _detailState createState() => _detailState();
}

class _detailState extends State<detail> {
  List<double> opacityLevel = [0,0,0];

  void _toggle(int index){
    setState(() {
      if(opacityLevel[index] == 0){
        opacityLevel[index] = 1;
      }else{
        opacityLevel[index] = 0;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title ?? 'non-title'),
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // シングルタップ時に呼ばれる
                _toggle(0);
              },
              // タッチ検出対象のWidget
              child: Text(
                'データベースからメモを入れる',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            AnimatedOpacity(
              opacity: opacityLevel[0],
              duration: const Duration(seconds: 3),
              child: const FlutterLogo(),
            ),
            GestureDetector(
              onTap: () {
                // シングルタップ時に呼ばれる
                _toggle(1);
              },
              // タッチ検出対象のWidget
              child: Text(
                'データベースからメモを入れる',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            AnimatedOpacity(
              opacity: opacityLevel[1],
              duration: const Duration(seconds: 3),
              child: const FlutterLogo(),
            ),
            GestureDetector(
              onTap: () {
                // シングルタップ時に呼ばれる
                _toggle(2);
              },
              // タッチ検出対象のWidget
              child: Text(
                'データベースからメモを入れる',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            AnimatedOpacity(
              opacity: opacityLevel[2],
              duration: const Duration(seconds: 3),
              child: const FlutterLogo(),
            ),
          ],
        ),
      ),
    );
  }
}
