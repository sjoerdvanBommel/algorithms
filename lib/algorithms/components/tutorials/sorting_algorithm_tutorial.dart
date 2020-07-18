import 'dart:math';

import 'package:algorithms/algorithms/components/tutorials/bubble_sort_tutorial_steps.dart';
import 'package:algorithms/algorithms/components/tutorials/sort_value.dart';
import 'package:algorithms/algorithms/components/tutorials/sorting_tutorial_step.dart';
import 'package:algorithms/algorithms/components/tutorials/steps_widget.dart';
import 'package:flutter/material.dart';

class SortingAlgorithmTutorial extends StatefulWidget {
  @override
  _SortingAlgorithmTutorialState createState() =>
      _SortingAlgorithmTutorialState();
}

class _SortingAlgorithmTutorialState extends State<SortingAlgorithmTutorial> {
  BubbleSortTutorialSteps bubbleSortTutorialSteps;
  List<SortValue> values;
  List<int> sortedIndexes;
  bool _changeValueButtonPressed = false;
  bool _loopActive = false;
  SortingTutorialStep currentStep;
  int stepNumber;

  Color getColor(int value) {
    Color a = Theme.of(context).backgroundColor;
    Color b = Theme.of(context).accentColor;
    double aStrength = ((values.length - 1) - value) / values.length;
    double bStrength = 1 - aStrength;
    return Color.fromARGB(
        (a.alpha * aStrength + b.alpha * bStrength).toInt(),
        (a.red * aStrength + b.red * bStrength).toInt(),
        (a.green * aStrength + b.green * bStrength).toInt(),
        (a.blue * aStrength + b.blue * bStrength).toInt());
  }

  Color getBorderColor(int index, int value) {
    return currentStep.isSelected?.call(index) == true
        ? Colors.red
        : sortedIndexes.contains(index) ? Colors.green : getColor(value);
  }

  void _changeValueWhileButtonPressed(bool add, int valueIndex) async {
    if (_loopActive) return;
    _loopActive = true;
    while (_changeValueButtonPressed) {
      int addValue = 0;
      if (add && values[valueIndex] < values.length - 1) addValue = 1;
      if (!add && values[valueIndex] > 1) addValue = -1;
      setState(() {
        values[valueIndex].value += addValue;
        currentStep = bubbleSortTutorialSteps.updateStep(values, currentStep);
      });
      await Future.delayed(Duration(milliseconds: 200));
    }
    _loopActive = false;
  }

  @override
  void initState() {
    reset();
    super.initState();
  }

  void reset() {
    values = List.generate(10, (index) => SortValue(Random().nextInt(9) + 1));
    sortedIndexes = List<int>();
    bubbleSortTutorialSteps = BubbleSortTutorialSteps(values, sortedIndexes);
    currentStep = bubbleSortTutorialSteps.getFirstStep();
    stepNumber = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
                'Step $stepNumber/${bubbleSortTutorialSteps.getAmountOfSteps()}'),
            GestureDetector(
              child: Text(
                'Reset',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () => setState(() => reset()),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: values
              .asMap()
              .entries
              .map(
                (e) => Container(
                  decoration: BoxDecoration(
                    color: getColor(e.value.value),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                        color: getBorderColor(e.key, e.value.value), width: 2),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: currentStep?.valuesChangeable == true
                            ? Listener(
                                onPointerDown: (details) {
                                  _changeValueButtonPressed = true;
                                  _changeValueWhileButtonPressed(true, e.key);
                                },
                                onPointerUp: (details) =>
                                    _changeValueButtonPressed = false,
                                child: Icon(Icons.add),
                              )
                            : null,
                      ),
                      SizedBox(height: 10),
                      Text(
                        e.value.value.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: currentStep?.valuesChangeable == true
                            ? Listener(
                                onPointerDown: (details) {
                                  _changeValueButtonPressed = true;
                                  _changeValueWhileButtonPressed(false, e.key);
                                },
                                onPointerUp: (details) =>
                                    _changeValueButtonPressed = false,
                                child: Icon(Icons.remove),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 20),
        StepsWidget(
          onBack: currentStep.previousStep != null
              ? () => setState(() {
                    currentStep.goBackFunction?.call();
                    currentStep = currentStep.previousStep;
                    stepNumber--;
                  })
              : null,
          onNext: currentStep.nextStep != null
              ? () => setState(() {
                    currentStep = currentStep.nextStep;
                    currentStep.function?.call();
                    stepNumber++;
                  })
              : null,
          child: Text(
            currentStep.explanation,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
