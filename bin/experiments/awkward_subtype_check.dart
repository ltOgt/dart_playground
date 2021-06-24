bool _awkwardSubTypeCheck<SUB, SUPER>() {
  // See https://github.com/dart-lang/language/issues/459#issuecomment-581365984
  return (<SUB>[] is List<SUPER>);
}

abstract class GenericBase {}

class GenericChild extends GenericBase {}

void main() {
  if (_awkwardSubTypeCheck<GenericChild, GenericBase>()) {
    // https://github.com/dart-lang/language/issues/459#issuecomment-581365984
    print("Oh wow");
  }

  Type b = GenericBase;
  Type c = GenericChild;

  // No way to check if c is subtype of b or GenericBase
}
