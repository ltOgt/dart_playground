abstract class GenericBase {}

class GenericChild extends GenericBase {}

class GenericReceiver<T extends GenericBase> {
  GenericReceiver() : assert(T != GenericBase);
}

void main() {
  GenericReceiver r;
  try {
    // annoying that this does not trigger lint
    r = GenericReceiver<GenericBase>();
    // what I actually want to avoid is the following:
    //GenericReceiver();
  } on AssertionError catch (_) {
    print("AssertionError as expected");
  }

  r = GenericReceiver<GenericChild>();
  print("No Error as expected");
}

/// Take the following abstract base class with multiple concrete implementations:
///
/// ```dart
/// abstract class GenericBase {}
///
/// class GenericChildOne extends GenericBase {}
/// class GenericChildTwo extends GenericBase {}
/// ```
///
/// The following class takes `GenericBase` as type parameter, but asserts that it only gets one of the concrete implementations instead of the abstract base:
/// ```dart
/// class GenericReceiver<T extends GenericBase> {
///   GenericReceiver() : assert(T != GenericBase);
/// }
/// ```
///
/// This however does not hinder users of that class to pass the generic type or specify none at all:
///
/// ```dart
/// final r1 = GenericReceiver();
/// final r2 = GenericReceiver<GenericBase>();
/// ```
