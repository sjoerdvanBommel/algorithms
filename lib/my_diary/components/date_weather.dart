import 'package:algorithms/my_diary/controllers/weather_controller.dart';
import 'package:algorithms/my_diary/date_formatter.dart';
import 'package:flutter/material.dart';

class DateWeather extends StatefulWidget {
  final WeatherController weatherController = WeatherController();

  @override
  _DateWeatherState createState() => _DateWeatherState();
}

class _DateWeatherState extends State<DateWeather> {
  Icon weatherIcon;

  @override
  void initState() {
    super.initState();
    updateWeatherIcon();
  }

  updateWeatherIcon() async {
    Icon icon = await widget.weatherController.getWeatherIcon(context);
    setState(() => weatherIcon = icon);
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
}
