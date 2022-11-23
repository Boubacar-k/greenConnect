import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smd/service/weather_api_client.dart';
import 'package:smd/weath/weather_model.dart';
import 'package:tflite/tflite.dart';
class Home_page extends StatefulWidget {
  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {

  File? imageFile;
  String? result;

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

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    imageClassification(imageFile!);
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    imageClassification(imageFile!);
  }

  @override
  void initState(){
    super.initState();
    loadModel();
  }
  Future loadModel() async {
    Tflite.close();
    String res;
    //res = (await Tflite.loadModel(model: "assets/model.tflite",labels: "assets/labels.txt"))!;
    print("Models loading status: res");
  }

  Future imageClassification(File image) async{
    var recognitions = await Tflite.runModelOnImage(path: image.path,numResults: 1,
    threshold: 0.05,imageMean: 127.5,imageStd: 127.5);
    setState(() {
      result = recognitions as String?;
      image = imageFile!;
    });
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
        expandedHeight: 500.0,
        backgroundColor: Color(0xffAEE7AD),
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            stretchModes: [StretchMode.zoomBackground],
            //title: Text('Home',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
            background: Stack(
              children: [
                Column(
                  children: [
                    TitleSection(),
                    Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.black,width: 2.0),
                      ),
                      child:imageFile!=null?Image.file(imageFile!,width: 240,height: 240,
                        fit: BoxFit.cover,):Icon(Icons.camera_alt_rounded,size: 200,),
                    )
                  ],
                )
              ],
            ),
        ),
        ),

      SliverToBoxAdapter(child: Container(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () => _getFromGallery(), child: Text('pick Gallery',style: TextStyle(color: Colors.black
                      ,fontWeight: FontWeight.bold),),style: ElevatedButton.styleFrom(
                      primary: Color(0xff63FFAF),elevation: 6.0,shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  )
                  ),),
                  ElevatedButton(onPressed: () => _getFromCamera(), child: Text('pick Camera',style: TextStyle(color: Colors.black
                      ,fontWeight: FontWeight.bold),),style: ElevatedButton.styleFrom(
                      primary: Color(0xff63FFAF),elevation: 6.0,shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  )
                  ),)
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,
              ),
              Container(
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
                          height: MediaQuery.of(context).size.height*0.02,
                        ),
                        if (imageFile!=null)Text("$result",style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),)
                      ],
                    )
                ),
              ),
              FutureBuilder(
              future: getData(),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.done)
                {return Padding(padding: EdgeInsets.only(top: 10),
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
                                    Text('Temperature:',style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold,color: Colors.black),
                                    ),
                                    SizedBox(height: 30,),
                                    Text('${data!.temp}°',style: TextStyle(fontSize: 15,
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
                          ],
                        ),
                        SizedBox(height: 10.0,),
                      ],
                    ));}else if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }else{
                  return Container(
                      child: Center(
                      child: Text(
                        "Please check your connection",style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 18,
                          color: Colors.black
                      ),
                      ),
                  ));
                }
              }),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Click for more details",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.greenAccent,
                    child: IconButton(
                      color: Colors.black,
                      onPressed: (){
                        Navigator.pushNamed(context, 'detailPage');
                      },
                      icon: Icon(Icons.arrow_forward),
                    ),
                  )
                ],)
            ],
          ),
          ),
          )
      ]),

    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      title: Text('Home',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
      backgroundColor: Colors.white.withOpacity(0),
    );
  }
}



class TitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Picture',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

