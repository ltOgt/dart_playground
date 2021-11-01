abstract class BaseType {}

class ChildA extends BaseType {}

class ChildB extends BaseType {}

class ChildC extends BaseType {}

class SubtypeOptions {
  final ChildA? childA;
  final ChildB? childB;
  final ChildB? childC;

  SubtypeOptions({
    this.childA,
    this.childB,
    this.childC,
  }) : assert(
          [
                childA,
                childB,
                childC,
              ].where((e) => e != null).length ==
              1,
          "Exactly one option must be provided",
        );

  // Can not be null, see assertion: exactly one must be present
  BaseType get child => childA ?? childB ?? childC ?? null!;
}

class SubtypeContainer<E extends BaseType> {
  final E child;
  Type get subtype => E;

  SubtypeContainer._(this.child);

  static SubtypeContainer<ChildA> childA() => SubtypeContainer._(ChildA());
  static SubtypeContainer<ChildB> childB() => SubtypeContainer._(ChildB());
  static SubtypeContainer<ChildC> childC() => SubtypeContainer._(ChildC());
}

class Receiver {
  SubtypeOptions options;
  SubtypeContainer container;
  Receiver({
    required this.options,
    required this.container,
  });

  void accessContainer() {}
}

void main() {
  Receiver(
    options: SubtypeOptions(
      childA: ChildA(),
    ),
    container: SubtypeContainer.childA(),
  );
}
