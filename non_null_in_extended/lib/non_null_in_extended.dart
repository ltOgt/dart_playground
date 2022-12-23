void main(List<String> args) {
  final childC = ChildConstructor(DateTime.now());
  childC.datetime!.day; // must use explicit promotion

  final childO = ChildOverwrite(DateTime.now());
  childO.dateTime.day; // is non-nullable

  doStuff(childO);
}

doStuff(Base some) {
  some.datetime?.day; // must use explicit promotion
  if (some is ChildOverwrite) {
    some.dateTime.day; // is non-nullable
  }
}

class Base {
  final DateTime? datetime;

  Base(this.datetime);

  Base.alternative(DateTime this.datetime);
}

class ChildConstructor extends Base {
  ChildConstructor(DateTime super.datetime);
}

class ChildOverwrite extends Base {
  ChildOverwrite(this.dateTime) : super(dateTime);

  final DateTime dateTime;
}

class BaseNonNull {
  final DateTime time;

  BaseNonNull(this.time);
}

class ChildNull extends BaseNonNull {
  //ChildNull(this.dateTime) : super(this.dateTime);
  ChildNull(this.dateTime) : super(dateTime ?? DateTime.now());

  final DateTime? dateTime;
}
