import 'dart:async' show Future;
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/services.dart' show rootBundle;
import '../models/chart.dart';

Future<String> _loadTweetAsset() async {
  return await rootBundle.loadString('lib/assets/twitter_data100.json');
}

Future<Map<String, dynamic>> loadChartData() async {
    String jsonTweets = await _loadTweetAsset();
    return  new ChartGenerator(json.decode(jsonTweets)).chartData;
}

class ChartGenerator {
  List<dynamic> tweetJson;
  Map<String, dynamic> chartData;

  ChartGenerator(List<dynamic> tweetJson){
    this.tweetJson = tweetJson;
    Map<String, dynamic> chartSets = this._generateSets();
    this.generateChartData(chartSets['wordSet'], chartSets['hashtagSet']);
  }

  void generateChartData(Set<String> wordSet, Set<String> hashtagSet) {

    Map<String, int> wordCount = {};
    Map<String, int> hashtagCount = {};

    // Initialize map data with word count
    for (String word in wordSet.toList())
      if (!wordCount.containsKey(word))
        wordCount[word] = 0;

    // Initialize map data with hashtags as keys and value is zero
    for (String hashtag in hashtagSet.toList())
      if (!hashtagCount.containsKey(hashtag))
        hashtagCount[hashtag] = 0;
  
    for (Map<String, dynamic> json in this.tweetJson) {
      if (json.containsKey('lang') && json['lang'] == "en") {
        if (json.containsKey('text')){
          List<String> words = json['text'].split(' ');
          for (String word in words)
            wordCount[word] += 1;
        }

        // Once set of hashtags is done, we count how hashtag occurence
        if (json.containsKey('entities') && json['entities'].containsKey('hashtags'))
          if (json['entities']['hashtags'].length > 0)
            for (Map<String, dynamic> hashtagObj in json['entities']['hashtags'])
              if (hashtagObj.containsKey('text'))
                hashtagCount[hashtagObj['text']] += 1;
      }
    }

    var sortedKeys = wordCount.keys.toList(growable:false)
                        ..sort((k2, k1) => wordCount[k1].compareTo(wordCount[k2]));
    LinkedHashMap sortedMap = LinkedHashMap
      .fromIterable(sortedKeys, key:(k) => k, value: (k) => wordCount[k]);

    List<WordData> wordDataList = [];
    for (var key in sortedMap.keys){
      if (wordDataList.length == 5)
        break;
      wordDataList.add(WordData(key, sortedMap[key]));
    }

    // sort by value
    sortedKeys = hashtagCount.keys.toList(growable:false)
                    ..sort((k2, k1) => hashtagCount[k1].compareTo(hashtagCount[k2]));
    sortedMap = new LinkedHashMap
      .fromIterable(sortedKeys, key: (k) => k, value: (k) => hashtagCount[k]);

    List<HashtagData> hashtagDataList = [];
    for(var key in sortedMap.keys){
      if (hashtagDataList.length == 5)
        break;
      hashtagDataList.add(HashtagData(key, sortedMap[key])); 
    }
    this.chartData = {'wordDataList': wordDataList, 'hashtagDataList': hashtagDataList };
  }

  Map<String, dynamic> _generateSets() {
    var hashtagSet = <String>{};
    var wordSet = <String>{};
    for (Map<String, dynamic> json in this.tweetJson) {
      if (json.containsKey('lang') && json['lang'] == "en") {
        if(json.containsKey('text')){
          List<String> words = json['text'].split(' ');
          for (String word in words)
            wordSet.add(word);
        }

        if (json.containsKey('entities') && json['entities'].containsKey('hashtags'))
            for (Map<String, dynamic> hashtagObj in json['entities']['hashtags'])
              if (hashtagObj.containsKey('text'))
                hashtagSet.add(hashtagObj['text']);
      }      
    }
    return {'wordSet': wordSet, 'hashtagSet': hashtagSet};
  }
}



