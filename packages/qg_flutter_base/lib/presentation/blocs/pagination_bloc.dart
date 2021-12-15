import 'package:riverbloc/riverbloc.dart';

class PaginationBloc<T extends List> extends Cubit<AsyncValue<T>> {
  final Future<T> Function(int page, int batchSize) fetch;
  int page;
  int batchSize;
  bool lastLoaded = false;

  PaginationBloc({
    required this.fetch,
    this.page = 0,
    this.batchSize = 20,
  }) : super(const AsyncValue.loading());

  Future<void> nextPage() async {
    if (lastLoaded && state is AsyncData) return;

    emit(const AsyncValue.loading());

    try {
      final data = await fetch(page++, batchSize);
      late T newData;
      if (state is AsyncData) {
        if (data.length < batchSize) {
          lastLoaded = true;
        }
        newData = [
          ...state.asData!.value,
          ...data,
        ] as T;
      } else {
        newData = data;
      }
      emit(AsyncValue.data(newData));
    } catch (error) {
      emit(AsyncValue.error(error));
    }
  }
}
