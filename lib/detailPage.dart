import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:smd/service/weather_api_client.dart';
import 'package:smd/weath/weather_model.dart';
import 'package:geolocator/geolocator.dart';

class Detail_page extends StatefulWidget {
  const Detail_page({Key? key}) : super(key: key);

  @override
  State<Detail_page> createState() => _Detail_pageState();
}

class _Detail_pageState extends State<Detail_page> {

  late Position _position;

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


  WeatherApiClient client = WeatherApiClient();
  Weather? data;
  Future<void> getData() async{
    Position position = await _determinePosition();
      _position = position;
    WidgetsFlutterBinding.ensureInitialized();
    print("Coordonate"+"lat = "+_position.latitude.toString()+"long ="+_position.longitude.toString());
    data = await client.getCurrentWeather(_position.latitude.toString(),_position.longitude.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return CustomScrollView(
              slivers: [
                SliverAppBar(
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
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(100))),
                  expandedHeight: 300.0,
                  backgroundColor: Color(0xffAEE7AD),
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    stretchModes: [StretchMode.zoomBackground],
                    background: Center(
                      child: (
                          Column(
                            children: [
                              Container(
                                padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Temperature',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.device_thermostat),
                                      Text(
                                        "${data!.temp}°",style: TextStyle(fontSize: 40.0,fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "${data!.name}",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      ),
                                    ],
                                  )
                              )
                            ],
                          )
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  width: 180,
                                  height: 200,
                                  padding: EdgeInsets.only(left: 10,right: 10,top:50,bottom: 50 ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.greenAccent
                                  ),
                                  child: Column(
                                    children: [
                                      Text('humidity:',style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold,color: Colors.black),
                                      ),
                                      SizedBox(height: 30,),
                                      Text('${data!.humidity}',style: TextStyle(fontSize: 15,
                                          fontWeight: FontWeight.bold,color: Colors.black),
                                      ),
                                    ],
                                  )
                              ),
                              Container(
                                  width: 180,
                                  height: 200,
                                  padding: EdgeInsets.only(left: 10,right: 10,top:50,bottom: 50 ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.greenAccent
                                  ),
                                  child: Column(
                                    children: [
                                      Text('wind:',style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold,color: Colors.black),
                                      ),
                                      SizedBox(height: 30,),
                                      Text('${data!.wind}',style: TextStyle(fontSize: 15,
                                          fontWeight: FontWeight.bold,color: Colors.black),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  width: 180,
                                  height: 200,
                                  padding: EdgeInsets.only(left: 10,right: 10,top:50,bottom: 50 ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.greenAccent
                                  ),
                                  child: Column(
                                    children: [
                                      Text('pressure:',style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold,color: Colors.black),
                                      ),
                                      SizedBox(height: 30,),
                                      Text('${data!.pressure}',style: TextStyle(fontSize: 15,
                                          fontWeight: FontWeight.bold,color: Colors.black),
                                      ),
                                    ],
                                  )
                              ),
                              Container(
                                  width: 180,
                                  height: 200,
                                  padding: EdgeInsets.only(left: 10,right: 10,top:50,bottom: 50 ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.greenAccent
                                  ),
                                  child: Column(
                                    children: [
                                      Text('Feels Like:',style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold,color: Colors.black),
                                      ),
                                      SizedBox(height: 30,),
                                      Text('${data!.feels_like}',style: TextStyle(fontSize: 15,
                                          fontWeight: FontWeight.bold,color: Colors.black),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          )
                        ],
                      )),
                )
              ],
            );
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if (snapshot.connectionState== ConnectionState.none){
            return Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  "Please check your connection",style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 18,
                    color: Colors.black
                ),
                ),
              ),
            );
          }
          return CustomScrollView();
        },
      )
    );
  }
}
