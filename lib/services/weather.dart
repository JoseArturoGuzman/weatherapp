import 'package:weatherapp/services/location.dart';
import 'package:weatherapp/services/networking.dart';
class WeatherModel {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey = '7f28a317e96eacc77dc598b551f96fe3';

  /// Obtiene los datos del clima basándose en el nombre de una ciudad.
  Future<dynamic> getWeatherDataByCity(String cityName) async {
    try {
      String url = '$baseUrl?q=$cityName&appid=$apiKey&units=metric';
      print('URL generada para la ciudad: $url'); // Imprime la URL

      Networking networking = Networking(url: url);
      var weatherData = await networking.getData();
      return weatherData;
    } catch (e) {
      print('Error al obtener datos de la ciudad: $e');
      return null;
    }
  }

  /// Obtiene los datos del clima basándose en la ubicación actual.
  Future<dynamic> getWeatherData() async {
    try {
      Location location = Location();
      await location.getCurrentPosition();

      if (location.latitude == null || location.longitude == null) {
        throw 'No se pudo obtener la ubicación actual.';
      }

      String url =
          '$baseUrl?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric';
      print('URL generada para la ubicación actual: $url'); // Imprime la URL

      Networking networking = Networking(url: url);
      var weatherData = await networking.getData();
      return weatherData;
    } catch (e) {
      print('Error al obtener datos de ubicación: $e');
      return null;
    }
  }

  /// Devuelve un icono representando el estado del clima.
  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  /// Devuelve un mensaje basado en la temperatura.
  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
