///
/// Motivation:
///
///   See three_way_lookup.dart
///
///

abstract class Indexable {
  List<IndexValue> get indexes;
}

/// Value that can be extracted from [Indexable] via [Indexable.indexes].
typedef IndexValue = Object;

/// Constructs N = [T.indexes.length] maps for all desired [IndexValue]s from [Indexable].
///
/// Allows to create multi-way associations between objects.
class NLookup<T extends Indexable> {
  /// List of maps for each desired [IndexValue] of [T].
  ///
  /// The order of the maps is determined by the order of [T.indexes].
  late final List<Map<IndexValue, T>> _nLookups;

  /// Create a map for each [IndexValue] as defined by [extractors].
  /// The map created from the `i`-th [T.indexes] can be accessed via [lookup]: `lookup(IndexValue indexKey, int i)`.
  NLookup(List<T> indexables) {
    assert(indexables.isNotEmpty);
    int numberOfIndexes = indexables.first.indexes.length;
    assert(indexables.every((i) => i.indexes.length == numberOfIndexes));

    _nLookups = [];

    for (int i = 0; i < numberOfIndexes; i++) {
      _nLookups.add({
        for (final idx in indexables) idx.indexes[i]: idx,
      });
    }
  }

  /// Lookup [T] based on [IndexValue]s.
  /// The desired [IndexValue] must have been contained in [T.indexes].
  /// If [slot] is specified, the [IndexValue] will be assumed to have been extracted from [T.indexes]`[slot]`.
  /// If no [slot] is specified, all N maps are checked.
  T? lookup(IndexValue indexKey, [int? slot]) {
    if (slot != null) {
      return _nLookups[slot][indexKey];
    }
    for (final lookup in _nLookups) {
      dynamic result = lookup[indexKey];
      if (result != null) return result;
    }
    return null;
  }
}

// ============================================== Example classes
abstract class Response {}

abstract class Request {}

class Method1Request extends Request {}

class Method1Response extends Response {}

class Method2Request extends Request {}

class Method2Response extends Response {}

class Mapping extends Indexable {
  final String path;
  final Type requestType;
  final Type responseType;

  Mapping({
    required this.path,
    required this.requestType,
    required this.responseType,
  });

  @override
  List<IndexValue> get indexes => [path, requestType, responseType];
}

class MappingLookup {
  late final NLookup<Mapping> _lookup;

  MappingLookup(List<Mapping> mappings) {
    _lookup = NLookup<Mapping>(mappings);
  }

  Mapping? _slot(IndexValue value, int slot) {
    return _lookup.lookup(value, slot);
  }

  Mapping? path(String path) => _slot(path, 0);
  Mapping? requestType(Type type) => _slot(type, 1);
  Mapping? request(Request r) => requestType(r.runtimeType);
  Mapping? responseType(Type type) => _slot(type, 2);
  Mapping? response(Response r) => responseType(r.runtimeType);
}

// ============================================== EXAMPLE RUNNER
class NWayLookup {
  static run() {
    final m1 = Mapping(
      path: "method_one",
      requestType: Method1Request,
      responseType: Method1Response,
    );

    final m2 = Mapping(
      path: "method_two",
      requestType: Method2Request,
      responseType: Method2Response,
    );

    final ml = MappingLookup([m1, m2]);

    void t() => throw "Mapping Error";

    if (m1 != ml.path(m1.path)) t();
    if (m1 != ml.request(Method1Request())) t();
    if (m1 != ml.response(Method1Response())) t();

    if (m2 != ml.path(m2.path)) t();
    if (m2 != ml.request(Method2Request())) t();
    if (m2 != ml.response(Method2Response())) t();

    print("works");
  }
}
