class Weather{
  String? name ;
  double? temp;
  double? wind;
  int? humidity;
  int? pressure;
  double? feels_like;

  Weather({
    this.name,
    this.temp,
    this.wind,
    this.humidity,
    this.pressure,
    this.feels_like});

  Weather.fromJson(Map<String,dynamic> json){
    name = json["name"];
    temp = json["main"]["temp"];
    wind = json["wind"]["speed"];
    pressure = json["main"]["pressure"];
    humidity = json["main"]["humidity"];
    feels_like = json["main"]["feels_like"];

  }
}