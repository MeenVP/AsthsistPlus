import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:air_quality/air_quality.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



String openWeatherApiKey =  "28b9c34654948faee1094caed2f5c5f1";
WeatherFactory wf = WeatherFactory(openWeatherApiKey );
AirQuality airQuality = AirQuality("5b68deb2b5925f3c1721a676504682b05ad3e914");

void enableGPSService()async {
  bool serviceStatus = await Geolocator.isLocationServiceEnabled();
  if(serviceStatus){
    print("GPS service is enabled");
  }else{
    print("GPS service is disabled.");
  }
}

void checkPermission()async{
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
    }else if(permission == LocationPermission.deniedForever){
      print('Location permissions are permanently denied');
    }else{
      print('GPS Location service is granted');
    }
  }else{
    print('GPS Location permission granted.');
  }

}



Future<Weather> getWeatherData() async {
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  Weather w = await wf.currentWeatherByLocation(position.latitude, position.longitude);
  return w;
}

Future<AirQualityData> getAirQualityData() async{
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  AirQualityData airQualityData = await airQuality.feedFromGeoLocation(position.latitude, position.longitude);
  return airQualityData;
}

Future<Map<String, dynamic>> getAirPollutionData() async {
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  final response = await http.get(
    Uri.parse('http://api.openweathermap.org/data/2.5/air_pollution?lat=${position.latitude}&lon=${position.longitude}&appid=$openWeatherApiKey'),
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    Map<String, dynamic> data = jsonDecode(response.body);
    Map<String, dynamic> pollutionData = {
      'no2': data['list'][0]['components']['no2'],
      'so2': data['list'][0]['components']['so2'],
      'pm2_5': data['list'][0]['components']['pm2_5'],
    };
    return pollutionData;
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load air pollution data');
  }
}

Future<String> getAirQualityIndex()async {
  AirQualityData airQuality = await getAirQualityData();
  return airQuality.airQualityIndex.toString();
}

Future<String> getTemperature()async {
  Weather weather = await getWeatherData();
  String temperature = weather.temperature.toString().split(' ')[0];
  return temperature;
}

Future<String> getHumidity()async {
  Weather weather = await getWeatherData();
  String humidity = weather.humidity.toString().split(' ')[0];
  return humidity;
}





