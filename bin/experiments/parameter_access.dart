/*
class UserNow {
  UserNow({this.b = 2, required this.c});

  final int b;
  final int c;

  Used doStuff() {
    return Used(
      0,
      b: b,
      c: c,
    );
  }
}

class Used {
  final int a;
  final int b;
  final int c;

  Used(
    this.a, {
    this.b = 2,
    required this.c,
  });
}

class UserImproved {
  UserImproved(this.usedPart, this.usedWhole);

  final Used*{b,c} usedPart;
  final Used* usedWhole;

  Used doStuff() {
    return Used(
      0,
      ...usedPart,
    );
  }

  Used doStuff2() {
    return Used(
      0,
      b: usedPart.b,
      c: usedPart.c,
    );
  }
}

main() {
  UserImproved(Used*{c: 4}, Used*{1, b:5, c: 3});
}
*/

// TODO maybe there is a way to use pattern matching to achieve something like this?

class UsedBy {
  final int a;
  final int b;

  UsedBy(int x, {int y = 10})
      : a = x,
        b = y;

  UsedBy.named(int both) : a = both, b=both;

  doStuff(String s, {String? s2 = ""}) {}
}

class UserOfNow {
  UserOfNow(this.x, {this.y = 10});
  UserOfNow.named(int both) : x = both, y=both;

  final int x;
  final int y;

  UsedBy use() {
    return UsedBy(x, y: y);
  }

  doStuff(String s, {String? s2 = ""}) {
    use().doStuff(s, s2: s2);
  }
}

class UserOfFwd {
  UserOfFwd(this.usedBy);
  UserOfFwd.named(this.usedByNamed);

  final UsedBy#? usedBy;
  final UsedBy#named? usedByNamed;
}
