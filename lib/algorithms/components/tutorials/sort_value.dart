import 'dart:collection';

class SortValue {
  Queue<int> _values = Queue<int>();

  SortValue(int value) {
    this.value = value;
  }

  SortValue.clone(SortValue val) : this(val.value);

  get value => _values.last;
  set value(int val) => _values.addLast(val);

  get valueBeforeSwap {
    if (_values.length > 1) _values.removeLast();
    return value;
  }

  bool operator <(val) => val is SortValue ? value < val.value : value < val;
  bool operator >(val) => val is SortValue ? value > val.value : value > val;
}
