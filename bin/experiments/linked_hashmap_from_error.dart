import 'dart:collection';

main(List<String> args) {
  final map = LinkedHashMap<String, Set<int>>.from({
    "a": {1, 2, 3}
  });

  Set.from(map["a"]!);

  LinkedHashMap<String, Set<int>> copy;
  // SOLUTION: was missing explicit cast in Set.from(map[key]!)
  final comprehension = {for (final key in map.keys) key: Set<int>.from(map[key]!)};
  copy = LinkedHashMap<String, Set<int>>.from(comprehension);
}
