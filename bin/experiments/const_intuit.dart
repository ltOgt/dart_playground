const canConst = CanConst(1);
const canNotConst = CanNotConst(1); // Error
const canNotConstContainer = CanNotConstContainer(CanNotConst(1)); // Error

class CanConst {
  final int value;
  const CanConst(this.value);
}

class CanNotConst {
  final int value;
  CanNotConst(this.value);
}

class CanNotConstContainer {
  final CanNotConst cnc;
  const CanNotConstContainer(this.cnc); // Should this not be an error? No way to get const cnc
}

CanConst test(int v) => const CanConst(v);
const v = 1;
const c = CanConst(v);
