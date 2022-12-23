typedef ModelUpdater<T extends ModelWrite> = void Function(T writer);

abstract class ReadOnlyModel {}

abstract class ReadOnlyModelWriter<T extends ReadOnlyModel> {}

// everything below would be generated from a template or via macros

class ModelRead extends ReadOnlyModel {
  int _myValue = 1;
  int get myValue => _myValue;

  int _myValue2 = 1;
  int get myValue2 => _myValue2;

  void notify() {
    print("Notify");
  }

  // can still only use one general purpose function that can update multiple values at once
  // and only notify listeners at the end
  void update(ModelUpdater<ModelWrite> updater) => _update(updater);
  void _update(ModelUpdater<ModelWrite> updater) {
    updater(ModelWrite._(this));
    notify();
  }
}

class ModelWrite extends ReadOnlyModelWriter<ModelRead> {
  final ModelRead _model;
  ModelWrite._(this._model);

  // can still be used for reference lookup
  set myValue(int newValue) {
    _model._myValue = newValue;
  }

  // can still be used for reference lookup
  set myValue2(int newValue) {
    _model._myValue2 = newValue;
  }
}

void main() {
  final myModel = ModelRead();

  myModel.update((writer) {
    writer.myValue = myModel.myValue * 2;
    writer.myValue2 = myModel.myValue2 * 4;
  });

  print(myModel.myValue);
  print(myModel.myValue2);
}
