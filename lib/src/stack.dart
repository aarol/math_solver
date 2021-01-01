import 'dart:collection';

class Stack<T> {
  final ListQueue<T> _list = ListQueue();

  bool get isNotEmpty => _list.isNotEmpty;
  bool get isEmpty => _list.isEmpty;

  void push(T e) => _list.addLast(e);

  T pop() => _list.removeLast();

  T get top => _list.last;

  bool contains(T x) {
    for (var item in _list) {
      if (x == item) return true;
    }
    return false;
  }

  List<T> toList() {
    return _list.toList();
  }
}
