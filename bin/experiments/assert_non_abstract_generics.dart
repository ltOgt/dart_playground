abstract class GenericBase {}

class GenericChild extends GenericBase {}

class GenericReceiver<T extends GenericBase> {
  GenericReceiver() : assert(T != GenericBase);
}

void main() {
  GenericReceiver r;
  try {
    r = GenericReceiver<GenericBase>();
  } on AssertionError catch (e) {
    print("AssertionError as expected");
  }

  r = GenericReceiver<GenericChild>();
  print("No Error as expected");
}
