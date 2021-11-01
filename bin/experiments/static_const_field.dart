class ClassA {
  final String strA;

  const ClassA(this.strA);

  static const ClassA defaults = ClassA("default");
}

class ClassB {
  final String strB;

  const ClassB(this.strB);

  static const ClassB defaults = ClassB(ClassA.defaults.strA);
}
