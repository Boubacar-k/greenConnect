import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_charts/charts.dart'as chart;
import 'package:tflite/tflite.dart';
import 'package:smd/service/weather5_api_client.dart';
import 'package:smd/weath/weather_model.dart';

class Detail_page extends StatefulWidget {
  final File? imageF;
  const Detail_page({Key? key, required this.imageF}) : super(key: key);

  @override
  State<Detail_page> createState() => _Detail_pageState();
}

class _Detail_pageState extends State<Detail_page> {

  List? results;
  final modelFile =  'converted_model.tflite';
  late chart.TooltipBehavior _tooltipBehavior;
  late Position _position;
  @override
  void initState(){
    _tooltipBehavior = chart.TooltipBehavior(enable: true);
    super.initState();
    //loadModel();
    _getData();
    //regression(super.widget.imageF!);
  }
  // Future<void> regression(File image) async {
  //   Interpreter inter = await Interpreter.fromAsset(modelFile);
  //   var input = image.absolute;
  //   var output = List.filled(1*2, 0).reshape([1,2]);
  //   inter.run(input, output);
  //   setState(() {
  //     results = output;
  //     print("------------------------------------------------------------------$results");
  //   });
  // }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error("permission denied");
      }
    }

    return await Geolocator.getCurrentPosition();
  }


  Weather5ApiClient client = Weather5ApiClient();
  Weather? data;
  Future<void> getData() async{
    Position position = await _determinePosition();
    _position = position;
    WidgetsFlutterBinding.ensureInitialized();
    print("Coordonate"+"lat = "+_position.latitude.toString()+"long ="+_position.longitude.toString());
    data = await client.getCurrent5Weather(_position.latitude.toString(),_position.longitude.toString());
    print("Data temperature = ${data!.temp}");
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(model: "assets/converted_model.tflite"))!;
    print("Models loading status: $res");
  }
  Future imageClassification(File image) async{
    var recognitions = await Tflite.runModelOnImage(path: image.path,numResults: 1,
        threshold: 0.05,imageMean: 127.5,imageStd: 127.5);
    setState(() {
      results = recognitions;
      image = super.widget.imageF!;
    });}

  _getData() async {
    imageClassification(super.widget.imageF!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(100))),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            /*shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(100))),*/
            expandedHeight: 460.0,
            backgroundColor: Color(0xffAEE7AD),
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              stretchModes: [StretchMode.zoomBackground],
              //title: Text('Home',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
              background: Stack(
                children: [
                  Positioned (child:Container(
                    height: 200,
                    width: 200,
                    padding: EdgeInsets.only(left: 80,right: 80,top: 30,bottom: 30),
                    child: super.widget.imageF!=0?Image.file(super.widget.imageF!,width: 100,height: 100):Icon(Icons.image)

                  ),
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0),
                  Positioned(
                    child: Container(
                      child: (
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Prediction:',style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17.0,
                                  color: Colors.black,
                                ),),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height*0.01,
                                ),
                                if(super.widget.imageF!=null)FutureBuilder(
                                    future: Future.delayed(Duration(seconds: 2)),
                                    builder: (context,snapshot){
                                      if(snapshot.connectionState == ConnectionState.done){
                                        return Text("Moisture :${results![0]["confidence"].toString()}",style: TextStyle(
                                          fontSize: 8.0,
                                          color: Colors.black,
                                        ),);
                                      }
                                      return Container();
                                    })

                              ]
                          )
                      ),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(50),
                        ),
                      ),
                    ),
                    bottom: -1,
                    left: 0,
                    right: 0,)
                ],
              ),
            ),),
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                child: chart.SfCartesianChart(
                    primaryXAxis: chart.CategoryAxis(),
                    // Chart title
                    title: chart.ChartTitle(text: 'Analysis'),
                    // Enable legend
                    legend: chart.Legend(isVisible: false),
                    // Enable tooltip
                    tooltipBehavior: _tooltipBehavior,

                    series: <chart.LineSeries<SalesData, String>>[
                      chart.LineSeries<SalesData, String>(
                          dataSource:  <SalesData>[
                            SalesData('Dec',10),
                            SalesData('Jan',5),
                            SalesData('Feb',20),
                            SalesData('Mar',15),
                          ],
                          xValueMapper: (SalesData sales, _) => sales.temperature,
                          yValueMapper: (SalesData sales, _) => sales.moisture,
                          // Enable data label
                          dataLabelSettings: chart.DataLabelSettings(isVisible: true)
                      )
                    ]
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.temperature,this.moisture);
  final String temperature;
  final double moisture;
}
