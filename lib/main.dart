import 'package:flutter/material.dart';
import 'package:flutter_tsa/screens/screens.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Twitter Sentiment Analysis',
      home: new MyTabBar()
    );
  }
}

class MyTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Theme(
        data: ThemeData(brightness: Brightness.light),
        child: Scaffold(
          bottomNavigationBar: TabBar(
            labelColor: Colors.blue,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.home,), text: "Home"),
              Tab(icon: Icon(Icons.insert_chart,), text: "Stats"),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              TwitterSentimentAnalysis(),
              HashtagChart(),
            ],
          ),
        ),
      ),
    );
  }
}


