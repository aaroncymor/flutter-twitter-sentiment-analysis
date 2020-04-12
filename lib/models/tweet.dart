import 'package:stemmer/stemmer.dart';

class User {
  String screenName;
  String profileImageUrl;

  User({this.screenName, this.profileImageUrl});
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      screenName: json['screen_name'],
      profileImageUrl: json['profile_image_url']
    );
  }
}

class Tweet {
  String text;
  String lang;
  User user;
  double sentimentScore;

  Tweet(String text, String lang, User user, Map corpus){
    this.text = text;
    this.lang = lang;
    this.user = user; 
    this._calcSentimentScore(corpus);
  }

  factory Tweet.fromJson(Map<String, dynamic> json, Map corpus) {
    Tweet tweet = new Tweet(
      json['text'],
      json['lang'],
      User.fromJson(json['user']),
      corpus,
    );
    
    return tweet;
  }

  void _calcSentimentScore(Map corpus) {
    PorterStemmer stemmer = new PorterStemmer();
    List<String> words = text.split(' ');
    int totalScore = 0;
    int wordCtr = 0;

    if (this.lang == "en"){
      for (final word in words) {
        String stemmedWord = stemmer.stem(word);
        if (corpus.containsKey(stemmedWord)) {
          totalScore += corpus[stemmedWord];
          wordCtr++;
        }
      }
    }

    if (wordCtr > 0) {
      this.sentimentScore = (totalScore / wordCtr).toDouble();
    } else {
      this.sentimentScore = 0.0;
    }
  }
}

class TweetList {
  List<Tweet> tweets;

  TweetList({this.tweets});

  factory TweetList.fromJson(List<dynamic> tweetJson, Map corpusJson) {
    List<Tweet> tweets = tweetJson.map((i) => Tweet.fromJson(i, corpusJson)).toList();
    return new TweetList(tweets: tweets);
  }


}