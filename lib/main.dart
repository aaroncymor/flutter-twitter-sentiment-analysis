import 'package:flutter/material.dart';
import 'services/tweet_services.dart';
import 'models/tweet.dart';
import 'charts.dart';

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

class TwitterSentimentAnalysis extends StatefulWidget {
  @override
  createState() => _TwitterSentimentAnalysisState();
}

class _TwitterSentimentAnalysisState extends State<TwitterSentimentAnalysis> {
  Widget _buildTweetSentimentScoreList() {
    return new FutureBuilder(
      future: loadTweets(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      }
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot){
    List<Tweet> tweetList = snapshot.data;
    return new ListView.builder(
      itemCount: tweetList.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new ListTile(
              title: new Text(tweetList[index].text + " SCORE: " + tweetList[index].sentimentScore.toString())
            ),
            new Divider(height: 2.0),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Tweet Scores'),
      ),
      body:  _buildTweetSentimentScoreList(),
    );
  }
}

