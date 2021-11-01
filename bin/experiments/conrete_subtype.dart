void main() {
  //assertCorrectImpl(ImplOne());
  //assertCorrectImpl<ImplOne>(ImplTwo());
  //assertCorrectImpl<ImplOne>(ImplOne());
}

abstract class Base {}

class ImplOne implements Base {}

class ImplTwo implements Base {}

void assertCorrectImpl<Spec extends Base>(Base actual) {
  if (Spec == Base) {
    throw "Must specify concrete Subtype of CanvasInputOptions";
  }
  if (false == (actual is Spec)) {
    throw "Incorrect Impl. Required <$Spec> but got <${actual.runtimeType}>";
  }
}

class BaseCtrl<T extends Base> {
  BaseCtrl._(this.options) {
    if (T == Base) throw "AAA";
  }

  T options;
}

class BaseCtrlFactory {
  static BaseCtrl<ImplOne> implOne(ImplOne options) => BaseCtrl._(options);
  static BaseCtrl<ImplTwo> implTwo(ImplTwo options) => BaseCtrl._(options);
}
