class MyBaseClass {
  final int myVar;

  MyBaseClass(this.myVar);

  void doStuff() {
    print("Hello From Base");
  }
}

class MyChildClass extends MyBaseClass {
  MyChildClass(int myVar) : super(myVar);

  @override
  doStuff() {
    super.doStuff();
    print("Hello From Child");
  }
}

void doStuffFromClass(MyBaseClass c) {
  c.doStuff();
}

void main() {
  MyBaseClass c = MyChildClass(0);

  doStuffFromClass(c);
}
