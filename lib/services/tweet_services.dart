import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/tweet.dart';


Future<String> _loadCorpusAsset() async {
  return await rootBundle.loadString('lib/assets/corpus.json');
}

Future<String> _loadTweetAsset() async {
  return await rootBundle.loadString('lib/assets/twitter_data100.json');
}

Future<List<Tweet>> loadTweets() async {
  String jsonTweets = await _loadTweetAsset();
  String jsonCorpus = await _loadCorpusAsset();

  final tweetJson = json.decode(jsonTweets);
  final Map corpusJson = json.decode(jsonCorpus);

  TweetList tweetList = TweetList.fromJson(tweetJson, corpusJson);
  return tweetList.tweets;
}
