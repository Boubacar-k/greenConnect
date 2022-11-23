import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:smd/service/weather_api_client.dart';
import 'package:smd/weath/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Detail_page extends StatefulWidget {
  const Detail_page({Key? key}) : super(key: key);

  @override
  State<Detail_page> createState() => _Detail_pageState();
}

class _Detail_pageState extends State<Detail_page> {

  /*List<ChartPointDetails> chartData = <ChartPointDetails>[
    ChartPointDetails(x: DateTime(2015, 1, 1, 0), yValue: 1.13),
    ChartPointDetails    ChartPointDetails(x: DateTime(2015, 1, 3, 3), yValue: 1.08),
    ChartSampleData(x: DateTime(2015, 1, 4, 4), yValue: 1.12),
    ChartSampleData(x: DateTime(2015, 1, 5, 5), yValue: 1.1),
    ChartSampleData(x: DateTime(2015, 1, 6, 6), yValue: 1.12),
    ChartSampleData(x: DateTime(2015, 1, 7, 7), yValue: 1.1),
    ChartSampleData(x: DateTime(2015, 1, 8, 8), yValue: 1.12),
    ChartSampleData(x: DateTime(2015, 1, 9, 9), yValue: 1.16),
    ChartSampleData(x: DateTime(2015, 1, 10, 10), yValue: 1.1),
  ];*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Center(
          //Initialize the chart widget
          child: Container(
              height: 500,
              width: 320,
              child: SfCartesianChart(
                  backgroundColor: Colors.white,
                  //Specifying date time interval type as hours
                  primaryXAxis: DateTimeAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      intervalType: DateTimeIntervalType.hours),
                  //series: <ChartSeries<ChartSampleData, DateTime>>[
                    //LineSeries<ChartSampleData, DateTime>(
                      //dataSource: chartData,
                      //xValueMapper: (ChartSampleData sales, _) => sales.x,
                      //yValueMapper: (ChartSampleData sales, _) => sales.yValue,
                      //name: 'Sales',
                    )
                 // ])),
        )
    ));
  }
}
