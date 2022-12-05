import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smd/weath/weather_model.dart';

class Weather5ApiClient{
  Future<Weather>?getCurrent5Weather(String? latitude, String longitude) async{
    var endpoint = Uri.parse("https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=b2a9a14a2d987afd9e43d7b6809ac69c&units=metric");

    var response = await http.get(endpoint);
    var body = jsonDecode(response.body);
    print(Weather.fromJson(body));
    return Weather.fromJson(body);
  }
}