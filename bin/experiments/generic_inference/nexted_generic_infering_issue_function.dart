void main() {
  // works
  GenericInferer(
    g: () => GenericSuper(),
  );

  var a = GenericInferWrap(
    inferer: GenericInferer(
      g: () => GenericSub(),
    ),
  );

  // this still is supertype ...
  print(a.inferer.gType);

  GenericInferWrap(
    // ok
    inferer: GenericInferer<GenericSub>(
      g: () => GenericSub(),
    ),
  );
}

class GenericSuper {}

class GenericSub extends GenericSuper {}

class GenericInferer<G extends GenericSuper> {
  final G Function() g;

  //Type get gType => (G != GenericSuper) ? G : g.returnType;
  late final Type gType;

  GenericInferer({
    required this.g,
  }) {
    //if (G == GenericSuper) throw "Not Subtype";

    // this replacement works:
    if (g.runtimeType == SuperFunc) throw "Not Subtype";
    // this seems to have the same problem with generic defined by enclosing object
    if (g.returnType == GenericSuper) throw "Not Subtype";

    gType = g.returnType;
  }
}

typedef SuperFunc = GenericSuper Function();

typedef GenericReturnFunction<R> = R Function();
typedef GenericSingleParamFunction<P> = Function(P param);

extension GenericReturnFunctionExtension<R> on GenericReturnFunction<R> {
  Type get returnType => R;
}

extension GenericSingleParamFunctionExtension<P> on GenericSingleParamFunction<P> {
  Type get paramType => P;
}

class GenericInferWrap {
  GenericInferer inferer;
  GenericInferWrap({
    required this.inferer,
  });
}
