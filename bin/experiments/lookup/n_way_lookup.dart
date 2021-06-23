///
/// Motivation:
///
///   See three_way_lookup.dart
///
///

/// Object which is to be indexed by [NLookup].
typedef ObjectContainingValuesToIndex = Object;

/// Value that can be extracted from [ObjectContainingValuesToIndex] via [IndexExtractor].
typedef IndexValue = Object;

/// Function to extract [IndexValue] from [ObjectContainingValuesToIndex].
typedef IndexExtractor<T extends ObjectContainingValuesToIndex> = IndexValue Function(T o);

/// Constructs N = [extractors.length] maps for all desired [IndexValue]s from [ObjectContainingValuesToIndex].
///
/// Allows to create multi-way associations between objects.
class NLookup<T extends ObjectContainingValuesToIndex> {
  /// List of maps for each desired [IndexValue] of [ObjectContainingValuesToIndex].
  ///
  /// The order of the maps is determined by the order of [extractors].
  late final List<Map<IndexValue, T>> _nLookups;

  /// Create a map for each [IndexValue] as defined by [extractors].
  /// The map created from the `i`-th [extractor] can be accessed via [lookup]`(indexKey, i)`.
  NLookup(List<T> objects, List<IndexExtractor<T>> extractors) {
    assert(objects.isNotEmpty);

    _nLookups = [];

    for (int i = 0; i < extractors.length; i++) {
      _nLookups.add({
        for (final o in objects) extractors[i](o): o,
      });
    }
  }

  /// Lookup [ObjectContainingValuesToIndex] based on [IndexValue]s.
  /// The desired [IndexValue] must have been extracted via [extractors] in the constructor.
  /// If [slot] is specified, the [IndexValue] will be assumed to have been extracted by [extractors]`[slot]`.
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

class Mapping {
  final String path;
  final Type requestType;
  final Type responseType;

  Mapping({
    required this.path,
    required this.requestType,
    required this.responseType,
  });
}

class MappingLookup {
  late final NLookup<Mapping> _lookup;

  MappingLookup(List<Mapping> mappings) {
    _lookup = NLookup<Mapping>(
      mappings,
      [
        (m) => m.path,
        (m) => m.requestType,
        (m) => m.responseType,
      ],
    );
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
main() {
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
