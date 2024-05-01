import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'api_key.dart';
import 'package:air_quality/air_quality.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'notifications.dart';

// get API keys from api_key.dart
WeatherFactory wf = WeatherFactory(openWeatherApiKey);
AirQuality airQuality = AirQuality(airQualityApiKey);

// check if GPS service is enabled
void enableGPSService() async {
  bool serviceStatus = await Geolocator.isLocationServiceEnabled();
  if (serviceStatus) {
    print("GPS service is enabled");
  } else {
    print("GPS service is disabled.");
  }
}

// check if GPS permission is granted
void checkPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
    } else if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
    } else {
      print('GPS Location service is granted');
    }
  } else {
    print('GPS Location permission granted.');
  }
}

// get weather data
Future<Weather> getWeatherData() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  Weather w =
      await wf.currentWeatherByLocation(position.latitude, position.longitude);
  return w;
}

// get air quality data
Future<AirQualityData> getAirQualityData() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  AirQualityData airQualityData = await airQuality.feedFromGeoLocation(
      position.latitude, position.longitude);
  return airQualityData;
}

// get air pollution data
Future<Map<String, dynamic>> getAirPollutionData() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  final response = await http.get(
    Uri.parse(
        'http://api.openweathermap.org/data/2.5/air_pollution?lat=${position.latitude}&lon=${position.longitude}&appid=$openWeatherApiKey'),
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

// get AQI
Future<String> getAirQualityIndex() async {
  AirQualityData airQuality = await getAirQualityData();
  if (airQuality.airQualityIndex > 100) {
    print('Unhealthy Air quality index');
    NotificationServices()
        .showNotification(5, airQuality.airQualityIndex.toString());
  }
  return airQuality.airQualityIndex.toString();
}

// get temperature
Future<String> getTemperature() async {
  Weather weather = await getWeatherData();
  String temperature = weather.temperature.toString().split(' ')[0];
  return temperature;
}

// get humidity
Future<String> getHumidity() async {
  Weather weather = await getWeatherData();
  String humidity = weather.humidity.toString().split(' ')[0];
  return humidity;
}
