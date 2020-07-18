import 'package:algorithms/my_diary/enums/month.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DiaryPages extends StatelessWidget {
  final CarouselController carouselController;
  final List<int> days = List.generate(50, (i) => i + 1);
  final int day = 1;

  DiaryPages({Key key, this.carouselController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CarouselSlider.builder(
        carouselController: carouselController,
        options: CarouselOptions(
          height: double.infinity,
          enableInfiniteScroll: false,
          initialPage: days.length - 1,
        ),
        itemCount: days.length,
        itemBuilder: (context, i) => Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(10, 20, 10, 40),
              child: DiaryPage(day: i),
            );
          },
        ),
      ),
    );
  }
}

class DiaryPage extends StatelessWidget {
  const DiaryPage({
    Key key,
    @required this.day,
  }) : super(key: key);

  final int day;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: AssetImage('assets/day${day % 4 + 1}.jpg'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                  blurRadius: 20,
                  color: Colors.grey[400],
                  offset: Offset(0, 10))
            ],
          ),
          width: 0.8 * MediaQuery.of(context).size.width,
        ),
        Positioned(
          left: 25,
          top: 10,
          child: Text(
            day.toString(),
            style: Theme.of(context).textTheme.headline1.copyWith(
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 8.0,
                  color: Color.fromARGB(125, 0, 0, 0),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 25,
          top: 130,
          child: Text(
            Month.AUG.label,
            style: Theme.of(context).textTheme.headline4.copyWith(
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 8.0,
                  color: Color.fromARGB(125, 0, 0, 0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
