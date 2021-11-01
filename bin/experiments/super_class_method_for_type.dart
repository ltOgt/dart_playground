main(List<String> args) {
  print(ChildClassOne().isBase); //   TRUE
  print(ChildClassOne().isChild1); // TRUE
  print(ChildClassOne().isChild2); // FALSE

  print(ChildClassTwo().isBase); //   TRUE
  print(ChildClassTwo().isChild1); // FALSE
  print(ChildClassTwo().isChild2); // TRUE
}

class BaseClass {
  bool get isBase => this is BaseClass;
  bool get isChild1 => this is ChildClassOne;
  bool get isChild2 => this is ChildClassTwo;
}

class ChildClassOne extends BaseClass {}

class ChildClassTwo extends BaseClass {}
