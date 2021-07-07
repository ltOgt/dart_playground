void main(List<String> args) {
  Function(String message) closure = (m) => print("no");

  final receiver = Receiver(closure: closure);

  closure = (String message) {
    print(message);
  };

  receiver.closure.call("Test");
}

class Receiver {
  Function(String message) closure;
  Receiver({
    required this.closure,
  });
}
