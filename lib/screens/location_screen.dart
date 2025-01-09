import 'package:flutter/material.dart';
import 'package:weatherapp/screens/city_screen.dart';
import 'package:weatherapp/services/weather.dart';
import 'package:weatherapp/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

final weather = WeatherModel();

class _LocationScreenState extends State<LocationScreen> {
  int temperature = 0;
  String weatherIcon = '☀️';
  String weatherMessage = 'Fetching weather data...';
  String cityName = '';

  @override
  void initState() {
    super.initState();
    DatosUI();
  }

  void DatosUI() async {
    try {
      var weatherData = await weather.getWeatherData();
      if (weatherData == null) {
        setState(() {
          weatherMessage = 'Unable to get weather data';
          weatherIcon = '🤷‍';
          cityName = '';
        });
        return;
      }

      setState(() {
        double temp = weatherData['main']['temp'];
        temperature = temp.toInt();
        var condition = weatherData['weather'][0]['id'];
        weatherIcon = weather.getWeatherIcon(condition);
        weatherMessage = weather.getMessage(temperature);
        cityName = weatherData['name'];
      });
    } catch (e) {
      print('Error in updateUI: $e');
      setState(() {
        weatherMessage = 'Unable to fetch weather data.';
        weatherIcon = '🤷‍';
        cityName = '';
      });
    }
  }

  void updateCityWeather(String cityName) async {
    try {
      var weatherData = await weather.getWeatherDataByCity(cityName);
      if (weatherData == null) {
        setState(() {
          weatherMessage = 'Unable to get weather data for $cityName';
          weatherIcon = '🤷‍';
          this.cityName = '';
        });
        return;
      }

      setState(() {
        double temp = weatherData['main']['temp'];
        temperature = temp.toInt();
        var condition = weatherData['weather'][0]['id'];
        weatherIcon = weather.getWeatherIcon(condition);
        weatherMessage = weather.getMessage(temperature);
        this.cityName = weatherData['name'];
      });
    } catch (e) {
      print('Error in updateCityWeather: $e');
      setState(() {
        weatherMessage = 'Unable to fetch city weather data.';
        weatherIcon = '🤷‍';
        cityName = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: DatosUI,
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var cityName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if (cityName != null) {
                        updateCityWeather(cityName);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
