import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            expandedHeight: 300.0,
            backgroundColor: Color(0xffAEE7AD),
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              stretchModes: [StretchMode.zoomBackground],
              //title: Text('Home',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
              background: Stack(
                children: [
                  Positioned(child:Container(
                    height: 100,
                    width: 100,
                    alignment: Alignment.center, // <---- The magic
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/image/data.svg',
                      semanticsLabel: 'Image',
                      height: 200,
                      width: 200,
                    ),
                  ),
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0),
                  Positioned(
                    child: Container(
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
            ),)
        ],
      ),
    );
  }
}
