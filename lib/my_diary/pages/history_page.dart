import 'package:algorithms/my_diary/components/date_weather.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import '../components/date_dropdowns.dart';
import '../components/diary_pages.dart';
import '../components/my_diary_navigation_bar.dart';
import 'package:algorithms/my_diary/components/flip_drawer.dart';

class HistoryPage extends StatelessWidget {
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlipDrawer(
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  DateWeather(),
                  SizedBox(height: 50),
                  DateDropdowns(),
                  DiaryPages(carouselController: carouselController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      OutlineButton(
                        onPressed: () => carouselController.previousPage(),
                        child: Text('Previous month',
                            style: TextStyle(color: Colors.grey[500])),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      SizedBox(width: 10),
                      OutlineButton(
                        onPressed: () => carouselController.nextPage(),
                        child: Text('Next month',
                            style: TextStyle(color: Colors.grey[500])),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
            bottomNavigationBar: MyDiaryNavigationBar(),
          ),
        ),
      ],
    );
  }
}
