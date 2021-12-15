import 'package:rxdart/rxdart.dart';

abstract class Search<SR, QP> {
  Search({
    required this.debounceTime,
    this.initialQueryParameter,
  }) {
    if (initialQueryParameter != null) {
      _searchImmediateSubject =
          // ignore: null_check_on_nullable_type_parameter
          BehaviorSubject<QP>.seeded(initialQueryParameter!);
    } else {
      _searchImmediateSubject = BehaviorSubject<QP>();
    }
    _searchDelayedSubject = BehaviorSubject<QP>();
  }

  QP? _currentQueryParameter;
  final QP? initialQueryParameter;
  final Duration debounceTime;

  late BehaviorSubject<QP> _searchDelayedSubject;
  late BehaviorSubject<QP> _searchImmediateSubject;

  Stream<List<SR>>? _searchDelayedStream;
  Stream<List<SR>>? _searchImmediateStream;

  Stream<List<SR>> get searchResultStream {
    _searchDelayedStream ??= _searchDelayedSubject.stream
        .debounceTime(debounceTime)
        .asyncMap((_e) => performSearch(_e))
        .distinct()
        .map(_filterFunction)
        .map(_sortFunction);
    _searchImmediateStream ??= _searchImmediateSubject.stream
        .asyncMap((_e) => performSearch(_e))
        .distinct()
        .map(_filterFunction)
        .map(_sortFunction);

    return Rx.merge([
      _searchDelayedStream!,
      _searchImmediateStream!,
    ]);
  }

  // ### FILTERING ###

  // ignore: prefer_function_declarations_over_variables
  List<SR> Function(List<SR> _results) _filterFunction = (_results) => _results;

  void setFilters(
    List<bool Function(SR resultElement)> filters, {
    bool shouldEmit = false,
  }) {
    _filterFunction = (_results) {
      final List<SR> _newResults = [];
      for (final _filter in filters) {
        _newResults.addAll(_results.where(_filter));
      }
      return _newResults;
    };
    if (shouldEmit && _currentQueryParameter != null) {
      // ignore: null_check_on_nullable_type_parameter
      triggerSearch(_currentQueryParameter!);
    }
  }

  // ### SORTING ###

  // ignore: prefer_function_declarations_over_variables
  List<SR> Function(List<SR> _results) _sortFunction = (_results) => _results;

  void setSort(
    List<SR> Function(List<SR>) sortFunction, {
    bool shouldEmit = false,
  }) {
    _sortFunction = sortFunction;
    if (shouldEmit && _currentQueryParameter != null) {
      // ignore: null_check_on_nullable_type_parameter
      triggerSearch(_currentQueryParameter!);
    }
  }

  void dispose() {
    _searchDelayedSubject.close();
    _searchImmediateSubject.close();
  }

  void triggerSearch(QP queryParameter) {
    _currentQueryParameter = queryParameter;
    _searchImmediateSubject.sink.add(queryParameter);
  }

  Future<List<SR>> performSearch(QP queryparameter);
}
