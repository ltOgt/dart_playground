/// https://github.com/dart-lang/language/issues/1713

void main() {
  print("-------------");
  final alone = GenericInferer(GenericBottom());

  print(alone.g == GenericBottom); //           true
  print(alone.runtimeType); //                  GenericInferer<GenericBottom>
  print(alone.genericField.runtimeType); //     GenericBottom

  // ------------------------ "ISSUE"
  print("-------------");
  final wrapped = Wrapper(GenericInferer(GenericBottom())).inferer;

  print(wrapped.g == GenericBottom); //         false
  print(wrapped.runtimeType); //                GenericInferer<GenericCenter>
  print(wrapped.genericField.runtimeType); //   GenericBottom

  // ------------------------ ~ "FIXES"
  print("-------------");
  final _postWrapped = GenericInferer(GenericBottom());
  final postWrapped = Wrapper(_postWrapped).inferer;

  print(postWrapped.g == GenericBottom); //       true
  print(postWrapped.runtimeType); //              GenericInferer<GenericBottom>
  print(postWrapped.genericField.runtimeType); // GenericBottom

  print("-------------");
  final explicitWrapped = Wrapper(GenericInferer<GenericBottom>(GenericBottom())).inferer;

  print(explicitWrapped.g == GenericBottom); //       true
  print(explicitWrapped.runtimeType); //              GenericInferer<GenericBottom>
  print(explicitWrapped.genericField.runtimeType); // GenericBottom
}

class GenericTop {}

class GenericCenter extends GenericTop {}

class GenericBottom extends GenericCenter {}

class GenericInferer<G extends GenericTop> {
  final G genericField;
  Type get g => G;
  GenericInferer(this.genericField);
}

/// This is not generic since I would like to have something like `List<GenericInferer<G>>` with different `G`
class Wrapper {
  final GenericInferer<GenericCenter> inferer;
  Type get g => inferer.g;
  Wrapper(this.inferer);
}
