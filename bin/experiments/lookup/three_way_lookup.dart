/// Motivation:
///
/// While trying to port [wedf_client_server] and  [codemap_client_server] to a new [bridge] package,
/// I wanted to not rely on METHOD_TYPE enums etc.
///
/// Needed a way to associate [Response], [Request] and [EnpointPath] (for rest request) and similar for socket rpc and notifications.
/// See [bridge/notes/api_convept_v1 and v2].

class TABase {}

class TBBase {}

class T1A extends TABase {}

class T1B extends TBBase {}

class T2A extends TABase {}

class T2B extends TBBase {}

void main() {
  testNL3();
  testNL();
  testMapping();
}

void testNL3() {
  final t1 = Triple<String, Type, Type>("t1", T1A, T1B);
  final t2 = Triple<String, Type, Type>("t2", T2A, T2B);

  // S | can not distinguish between type of types ie Type(T1A) and Type(T1B)
  var nl3 = NLookup3<String, Type, Type>([t1, t2]);

  var r1 = nl3.lookup("t1");
  var r2 = nl3.lookup("t2");
  // S | can not distinguish between type of types ie Type(T1A) and Type(T1B)
  // finds r3 since TABase is first, TBBase is also Type but not contained in second slot
  var r3 = nl3.lookup(T1A);
  var r4 = nl3.lookup(T2B);
}

void testNL() {
  // This works since we loop over all slots
  var nl = NLookup([
    ["t1", T1A, T1B],
    ["t2", T2A, T2B]
  ]);

  var r1 = nl.lookup("t1");
  var r2 = nl.lookup("t2");
  var r3 = nl.lookup(T1A);
  var r4 = nl.lookup(T2B);
}

void testMapping() {
  final ml = MappingLookup([
    Mapping(
      path: "method_one",
      requestType: Method1Request,
      responseType: Method1Response,
    ),
    Mapping(
      path: "method_two",
      requestType: Method2Request,
      responseType: Method2Response,
    ),
  ]);

  var r1 = ml.path("method_two");
  var r2 = ml.request(Method1Request());
  var r3 = ml.response(Method2Response());
}

class Triple<A, B, C> {
  final A a;
  final B b;
  final C c;

  Triple(this.a, this.b, this.c);
}

class NLookup3<A, B, C> {
  late final NLookup _lookup;

  NLookup3(List<Triple<A, B, C>> groups) {
    _lookup = NLookup(groups.map((e) => [e.a, e.b, e.c]).toList());
  }

  Triple<A, B, C>? lookup<T>(T value) {
    int slot;

    if (value is A) {
      slot = 0;
    } else if (value is B) {
      slot = 1;
    } else if (value is C) {
      slot = 2;
    } else {
      throw UnsupportedError("Value has incorrect type: ${value.runtimeType}");
    }
    List? result = _lookup.lookup(value, slot);
    if (result == null) return null;
    return Triple(result[0], result[1], result[2]);
  }
}

typedef GroupOfLengthN = List;

class NLookup {
  late final List<Map<dynamic, GroupOfLengthN>> _nLookups;

  NLookup(List<GroupOfLengthN> groups) {
    assert(groups.isNotEmpty);
    assert(groups.every((element) => element.length == groups.first.length));

    _nLookups = [];

    for (int i = 0; i < groups.first.length; i++) {
      _nLookups.add({
        for (final g in groups) g[i]: g,
      });
    }
  }

  GroupOfLengthN? lookup(dynamic value, [int? slot]) {
    if (slot != null) {
      return _nLookups[slot][value];
    }
    for (final lookup in _nLookups) {
      dynamic result = lookup[value];
      if (result != null) return result;
    }
    return null;
  }
}

// ==============================================
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
  late final NLookup _lookup;

  MappingLookup(List<Mapping> mappings) {
    _lookup = NLookup(mappings.map((e) => [e.path, e.requestType, e.responseType]).toList());
  }

  Mapping? _slot(dynamic value, int slot) {
    List? result = _lookup.lookup(value, slot);
    if (result == null) return null;
    return Mapping(
      path: result[0],
      requestType: result[1],
      responseType: result[2],
    );
  }

  Mapping? path(String path) => _slot(path, 0);
  Mapping? requestType(Type type) => _slot(type, 1);
  Mapping? request(Request r) => requestType(r.runtimeType);
  Mapping? responseType(Type type) => _slot(type, 2);
  Mapping? response(Response r) => responseType(r.runtimeType);
}
