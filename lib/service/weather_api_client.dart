import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smd/weath/weather_model.dart';

class WeatherApiClient{
  Future<Weather>?getCurrentWeather(String? latitude, String longitude) async{
    var endpoint = Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=b2a9a14a2d987afd9e43d7b6809ac69c&units=metric");

    var response = await http.get(endpoint);
    var body = jsonDecode(response.body);
    print(Weather.fromJson(body));
    return Weather.fromJson(body);
  }
}