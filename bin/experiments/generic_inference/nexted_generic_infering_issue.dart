void main() {
  // works
  GenericInferer(
    g: GenericSub(),
  );

  var a = GenericInferWrap(
    // throws
    inferer: GenericInferer(
      g: GenericSub(),
    ),
  );

  GenericInferWrap(
    // ok
    inferer: GenericInferer<GenericSub>(
      g: GenericSub(),
    ),
  );
}

class GenericSuper {}

class GenericSub extends GenericSuper {}

class GenericInferer<G extends GenericSuper> {
  final G g;

  GenericInferer({
    required this.g,
  }) {
    //if (G == GenericSuper) throw "Not Subtype";

    // this replacement works:
    if (g.runtimeType == GenericSuper) throw "Not Subtype";
  }
}

class GenericInferWrap {
  GenericInferer inferer;
  GenericInferWrap({
    required this.inferer,
  });
}
