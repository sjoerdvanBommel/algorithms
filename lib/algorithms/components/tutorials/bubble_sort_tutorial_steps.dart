import 'package:algorithms/algorithms/components/tutorials/sort_value.dart';
import 'package:algorithms/algorithms/components/tutorials/sorting_tutorial_step.dart';

class BubbleSortTutorialSteps {
  final List<SortValue> values;
  List<SortValue> _curValues;
  List<int> sortedIndexes;
  int _curIndex;

  BubbleSortTutorialSteps(this.values, this.sortedIndexes) {
    this._curValues = values.map((e) => SortValue.clone(e)).toList();
  }

  SortingTutorialStep updateStep(
      List<SortValue> values, SortingTutorialStep currentStep) {
    this._curValues = values.map((e) => SortValue.clone(e)).toList();
    SortingTutorialStep step = getFirstStep();
    while (step != currentStep) {
      step = step.nextStep;
    }
    return step;
  }

  SortingTutorialStep getFirstStep() {
    List<SortingTutorialStep> steps =
        List.generate(getAmountOfSteps() + 1, (index) => SortingTutorialStep());
    for (int i = 0; i < steps.length; i++) {
      steps[i].previousStep = i > 0 ? steps[i - 1] : null;
      steps[i].nextStep = i < steps.length - 1 ? steps[i + 1] : null;
    }

    steps[0]
      ..explanation =
          'In this tutorial we will discuss how the bubble sort algorithm works'
      ..valuesChangeable = true;
    steps[1]
      ..explanation =
          'As the description says: bubble sort will repeatedly swap the adjacent elements in an array until all elements are ordered'
      ..valuesChangeable = true;
    steps[2]
      ..explanation =
          'Before we start, you can change the values in case you want to'
      ..valuesChangeable = true;
    _curIndex = 0;
    steps[3]
      ..explanation =
          'We will start with comparing the first two values of the list'
      ..isSelected = ((i) => [0, 1].contains(i));
    steps[4] = getCompareStep(values, steps[4], _curIndex);
    _curIndex++;

    for (int i = 5; i < _curValues.length * 2; i += 2, _curIndex++) {
      swapIfNeeded(_curValues, _curIndex);
      steps[i] = getNextCompareStep(steps[i], _curIndex);
      steps[i + 1] = getCompareStep(values, steps[i + 1], _curIndex);
    }

    int curStep = _curValues.length * 2;

    steps[curStep + 1]
      ..explanation =
          'Now all values have been compared once, we are sure that the last value is sorted';
    steps[curStep + 2]
      ..explanation =
          'To make this more clear, it is marked with a green border';
    steps[curStep + 3]
      ..explanation = 'Now this process will repeat until all nodes are sorted';

    _curIndex = 0;
    for (int i = 1; i < _curValues.length - 1; i++, _curIndex = 0) {
      int nSteps = _curValues.length * 2 - (i + 1) * 2;
      for (int j = 0; j < nSteps; j += 2, _curIndex++) {
        int stepIndex = (curStep + 4) + j + nSteps * (i - 1) + i * (i - 1);
        swapIfNeeded(_curValues, _curIndex);
        steps[stepIndex] = getNextCompareStep(steps[stepIndex], _curIndex);
        steps[stepIndex + 1] =
            getCompareStep(values, steps[stepIndex + 1], _curIndex);
      }
    }

    curStep = getAmountOfSteps();

    steps[curStep]
      ..explanation = 'Now you know how bubble sort works, congratulations!'
      ..function = (() => sortedIndexes.add(0));

    return steps[0];
  }

  int getAmountOfSteps() {
    return (_curValues.length * (_curValues.length - 1) + 6).toInt();
  }

  SortingTutorialStep getCompareStep(
      List<SortValue> list, SortingTutorialStep step, int index) {
    return step
      ..explanation = list[index] > list[index + 1]
          ? 'Because the first value was bigger, the two values are swapped'
          : 'Because the first value is not bigger, the two values won\'t be swapped'
      ..function = (() {
        swapIfNeeded(list, index);
        if (index == list.length - 2 - sortedIndexes.length)
          sortedIndexes.add(index + 1);
      })
      ..goBackFunction = (() => swapIfNeeded(list, index, back: true))
      ..isSelected = ((i) => [index, index + 1].contains(i));
  }

  SortingTutorialStep getNextCompareStep(SortingTutorialStep step, int index) {
    return step
      ..explanation =
          'Now the values at indexes $index and ${index + 1} will be compared'
      ..isSelected = ((i) => [index, index + 1].contains(i));
  }

  void swapIfNeeded(List<SortValue> list, int i, {back: false}) {
    if (back) {
      list[i].valueBeforeSwap;
      list[i + 1].valueBeforeSwap;
    } else {
      int temp = list[i].value;
      int temp2 = list[i + 1].value;
      list[i].value = temp > temp2 ? temp2 : temp;
      list[i + 1].value = temp > temp2 ? temp : temp2;
    }
  }
}
