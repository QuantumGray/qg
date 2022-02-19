class MultiFutureAssembler<T> {
  final T initialResult;

  final List<FutureAssembler> _assemblers;

  MultiFutureAssembler(this._assemblers, this.initialResult);

  Future<T> assemble() {
    final futures = _assemblers.map((a) => a.future()).toList();
    return Future.wait(futures).then((values) {
      T currentResult = initialResult;
      for (var i = 0; i < _assemblers.length; i++) {
        final assembler = _assemblers[i];
        final future = values[i];
        currentResult = assembler.assemble(future, currentResult) as T;
      }
      return currentResult;
    });
  }
}

class FutureAssembler<T, F> {
  final Future<F> Function() future;
  final T Function(F future, T assemblee) assemble;

  FutureAssembler(this.future, this.assemble);
}
