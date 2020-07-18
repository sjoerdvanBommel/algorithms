import 'package:algorithms/my_diary/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather_library.dart';

class DateWeather extends StatefulWidget {
  @override
  _DateWeatherState createState() => _DateWeatherState();
}

class _DateWeatherState extends State<DateWeather> {
  final WeatherStation weatherStation =
      new WeatherStation("24cd6635b1fa75e22862e45c431fdfec");

  Icon weatherIcon;

  void getWeather() async {
    Position position = await Geolocator().getLastKnownPosition();
    Weather weather = await weatherStation.currentWeather(
        position.latitude, position.longitude);
    setState(() {
      weatherIcon = Icon(
        getWeatherIcon(weather.weatherIcon),
        color: Theme.of(context).primaryIconTheme.color,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, // Fixed AppBar height
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (weatherIcon != null)
            Container(height: 56, width: 56, child: weatherIcon),
          Container(
            padding: EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            child: Text(
              getDate(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }

  IconData getWeatherIcon(String icon) {
    switch (icon) {
      case '01d':
        return FlutterIcons.wi_day_sunny_wea;
      case '02d':
        return FlutterIcons.wi_day_cloudy_wea;
      case '03d':
        return FlutterIcons.wi_cloud_wea;
      case '04d':
        return FlutterIcons.wi_cloudy_wea;
      case '09d':
        return FlutterIcons.wi_showers_wea;
      case '10d':
        return FlutterIcons.wi_day_showers_wea;
      case '11d':
        return FlutterIcons.wi_storm_showers_wea;
      case '13d':
        return FlutterIcons.wi_snow_wea;
      case '50d':
        return FlutterIcons.wi_fog_wea;
      case '01n':
        return FlutterIcons.wi_night_clear_wea;
      case '02n':
        return FlutterIcons.wi_night_alt_cloudy_wea;
      case '03n':
        return FlutterIcons.wi_cloud_wea;
      case '04n':
        return FlutterIcons.wi_cloudy_wea;
      case '09n':
        return FlutterIcons.wi_showers_wea;
      case '10n':
        return FlutterIcons.wi_night_alt_showers_wea;
      case '11n':
        return FlutterIcons.wi_storm_showers_wea;
      case '13n':
        return FlutterIcons.wi_snow_wea;
      case '50n':
        return FlutterIcons.wi_fog_wea;
      default:
        return FlutterIcons.wi_cloud_wea;
    }
  }
}
