void main() {
  final gi = GenericInferer(
    returnGeneric: () => GenericSub(),
    // Oof this seems to be an issue again bco contravariant (without specifying the parameter explicitly)
    receiveGeneric: (GenericSub gs) => {gs.field},
  );
  print(gi.g);
}

class GenericSuper {}

class GenericSub extends GenericSuper {
  String get field => "";
}

class GenericInferer<G extends GenericSuper> {
  final G Function() _returnGeneric;
  final void Function(G p) _receiveGeneric;
  Type get g => G;

  GenericInferer({
    required G Function() returnGeneric,
    required void Function(G p) receiveGeneric,
  })  : _receiveGeneric = receiveGeneric,
        _returnGeneric = returnGeneric {
    print(G);
  }
}
