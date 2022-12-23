void main(List<String> args) {
  const m = MyLazyConst(1);
  print("m.value: ${m.value}");
  print("m._lazyValue.first: ${m._lazyValue.first}");
  print("m.lazyValue: ${m.lazyValue}");
}

// class MyLazyConst {
//   // // Can't have a late final field in a class with a const constructor.
//   // // dart(late_final_field_with_const_constructor)
//   // late final int value;
//   final int value;

//   const MyLazyConst(this.value) : _lazyValue = const [];
//   MyLazyConst.lazy(this.value) : _lazyValue = [];

//   final List<int>? _lazyValue;
//   int get lazyValue => _lazyValue[0] ??= value;
// }

class MyLazyConst {
  // // Can't have a late final field in a class with a const constructor.
  // // dart(late_final_field_with_const_constructor)
  // late final int value;
  final double dx, dy;
  final Offset? _constOrLazy;

  const MyLazyConst(double dx, double dy)
      : this.dy = dy,
        this.dx = dx,
        _constOrLazy = const Offset(dx, dy);

  //const MyLazyConst.zero() => const MyLazyConst(0, 0);
  static const MyLazyConst zero = MyLazyConst(0, 0);
}

class Offset {
  final double dx, dy;
  const Offset(this.dx, this.dy);
}

class MyOtherClass {
  final int value;
  const MyOtherClass(this.value);
}

class MyClass {
  final int value;
  final MyOtherClass? other;

  const MyClass(this.value, this.other);
  const MyClass.nullOther(this.value) : other = null;

  const MyClass.sameOther(int value)
      // why does this work ...
      : this.value = value,
        // ... but this does not
        other = MyOtherClass(value);
  // ------------------------------^^^^^--------------------------
  // Arguments of a constant creation must be constant expressions

  const MyClass.zero()
      : this.value = 0,
        this.other = const MyOtherClass(0);
  static const MyClass zeroField = const MyClass(0, MyOtherClass(0));
}

const zeroField = MyClass(0, MyOtherClass(0));
