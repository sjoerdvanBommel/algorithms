import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather_library.dart';

class WeatherController {
  final WeatherStation weatherStation =
      new WeatherStation("24cd6635b1fa75e22862e45c431fdfec");

  Future<Icon> getWeatherIcon(BuildContext context) async {
    String weatherIconString = await getWeatherIconString();
    return Icon(
      getIconData(weatherIconString),
      color: Theme.of(context).accentIconTheme.color,
    );
  }

  Future<String> getWeatherIconString() async {
    Position position = await Geolocator().getLastKnownPosition();
    return (await weatherStation.currentWeather(
            position.latitude, position.longitude))
        .weatherIcon;
  }

  IconData getIconData(String icon) {
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
