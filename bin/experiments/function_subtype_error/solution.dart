/// Context: wokring on bridge [EndpointDefiniton] and [EndpointClientInternal] (thoughts/v3)
/// https://github.com/dart-lang/language/issues/1701

class GenericBase {}

class GenericChild extends GenericBase {}

class FunctionOrigin<G extends GenericBase> {
  final void Function(G generic) func;

  FunctionOrigin(this.func);
}

// SOLUTION (https://github.com/dart-lang/language/issues/1701)
// : must add generic type to those functions, TODO try to better understand the explenation given in the answer

class FunctionUser {
  void useFuncClass<T extends GenericBase>(FunctionOrigin<T> origin, T genericInstance) {
    origin.func(genericInstance);
  }
}

void useFuncGlobal<T extends GenericBase>(FunctionOrigin<T> origin, T genericInstance) {
  origin.func(genericInstance);
}

void main() {
  final origin = FunctionOrigin<GenericChild>((GenericChild child) {
    print("works");
  });

  final genericInstance = GenericChild();

  print(" Calling from same scope");
  origin.func(genericInstance);

  try {
    print("\n Calling from within function inside class");
    FunctionUser().useFuncClass(origin, genericInstance);
  } catch (e) {
    print(e);
  }

  try {
    print("\n Calling from within function in global scope");
    useFuncGlobal(origin, genericInstance);
  } catch (e) {
    print(e);
  }

  //
  //
  //
  //

  final origin2 = FunctionOrigin((GenericBase child) {
    print("works");
  });

  final genericInstance2 = GenericBase();

  print("\n Calling from same scope");
  origin2.func(genericInstance2);

  try {
    print("\n Calling from within function inside class");
    FunctionUser().useFuncClass(origin2, genericInstance2);
  } catch (e) {
    print(e);
  }

  try {
    print("\n Calling from within function in global scope");
    useFuncGlobal(origin2, genericInstance2);
  } catch (e) {
    print(e);
  }
}
