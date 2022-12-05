import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smd/homePage.dart';

import 'package:smd/startPage.dart';
import 'package:smd/detailPage.dart';

void main() {
  File? imageToSend;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'startPage',
    routes: {
      'startPage':(context)=>Start(),
      'homePage':(context)=>Home_page(),
      'detailPage':(context)=>Detail_page(imageF: imageToSend)
    },
  ));
}


