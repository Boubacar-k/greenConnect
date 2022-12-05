import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffAEE7AD)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35,top: 130),
              child: Ink.image(image: AssetImage('assets/image/sol.png'),width: 100,height: 100,fit: BoxFit.cover,),
            ),
            Container(
              padding: EdgeInsets.only(left: 150,top: 130),
              child: Text("Green Connect",style: TextStyle(color: Colors.black,fontSize: 40,fontWeight: FontWeight.bold,fontStyle: FontStyle.normal),),
            ),
            Container(
              padding: EdgeInsets.only(left: 35,top: MediaQuery.of(context).size.height*0.3,right: 35),
              child:Column(
                children: [
                  SvgPicture.asset('assets/image/nature.svg',height: 300,),

                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Get started",style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold,),),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.greenAccent,
                        child: IconButton(
                          color: Colors.black,
                          onPressed: (){
                            Navigator.pushNamed(context, 'homePage');
                          },
                          icon: Icon(Icons.arrow_forward),
                        ),
                      )
                    ],)
                ],
              ),)
          ],
        ),
      ),
    );
  }
}
