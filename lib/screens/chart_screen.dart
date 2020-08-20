import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_tsa/services/chart_services.dart';
import 'package:flutter_tsa/models/chart.dart';

class HashtagChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hashtag Charts',
      home: new HashtagChart()
    );
  }
}

class HashtagChart extends StatefulWidget {
  @override
  createState() => _HashtagChartState();  
}

class _HashtagChartState extends State<HashtagChart> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Hashtag Chart")),
      body: _buildChartList()
    );
  }

  Widget _buildChartList() {
    return new FutureBuilder(
      future: loadChartData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createChartsView(context, snapshot);
        }
      }
    );
  }

  Widget createChartsView(BuildContext context, AsyncSnapshot snapshot) {
    List<WordData> wordDataList = snapshot.data['wordDataList'];
    List<HashtagData> hashtagDataList = snapshot.data['hashtagDataList'];
    return ListView(
      children: <Widget>[
        Container(
          height: 200.0,
          child: new charts.PieChart(
            wordSeriesList(wordDataList),
            defaultRenderer: new charts.ArcRendererConfig(
              arcRendererDecorators: [
                new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.outside
                )
              ]
            ),
          )
        ),
        Divider(height: 30.0),
        Container(
          height: 200.0,
          child: new charts.PieChart(
            hashtagSeriesList(hashtagDataList),
            defaultRenderer: new charts.ArcRendererConfig(
              arcRendererDecorators: [
                new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.outside
                )
              ]
            ),            
          ),
        ),
      ],
    );
  }

  List<charts.Series<WordData, String>> wordSeriesList(List<WordData> data){
    return [
      new charts.Series<WordData, String>(
        id: 'Top Words',
        data: data,
        domainFn: (WordData wordData, _) => wordData.word,
        measureFn: (WordData wordData, _) => wordData.count,
        labelAccessorFn: (WordData row, _) => '${row.word}: ${row.count}'
      ),
    ];
  }

  List<charts.Series<HashtagData, String>> hashtagSeriesList(List<HashtagData> data) {
    return [
      new charts.Series<HashtagData, String>(
        id: 'Top Hashtags',
        data: data,
        domainFn: (HashtagData hashtagData, _) => hashtagData.hashtag,
        measureFn: (HashtagData hashtagData, _) => hashtagData.count,
        labelAccessorFn: (HashtagData row, _) => '${row.hashtag} : ${row.count}',
      ),
    ];
  }

}