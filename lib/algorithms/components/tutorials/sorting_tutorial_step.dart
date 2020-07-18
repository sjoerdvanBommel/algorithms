class SortingTutorialStep {
  String explanation;
  bool valuesChangeable;
  SortingTutorialStep previousStep, nextStep;
  bool Function(int) isSelected;
  void Function() function, goBackFunction;

  SortingTutorialStep({
    this.explanation,
    this.previousStep,
    this.nextStep,
    this.isSelected,
    this.function,
    this.goBackFunction,
    this.valuesChangeable: false,
  });

  bool operator ==(sortingTutorialStep) =>
      sortingTutorialStep is SortingTutorialStep &&
      this.explanation == sortingTutorialStep.explanation;

  int get hashCode => this.explanation.hashCode * this.explanation.hashCode;
}
