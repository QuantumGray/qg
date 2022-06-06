import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qg_flutter_base/base/request_response.dart';
import 'package:qg_flutter_base/widgets/indicators.dart';

typedef LoadMoreCallback = Future<RequestResponse> Function(
  BuildContext context,
);

class LoadMore extends StatefulWidget {
  final Widget child;
  final LoadMoreCallback onLoadMore;
  final bool isFinish;

  const LoadMore({
    Key? key,
    required this.child,
    required this.onLoadMore,
    required this.isFinish,
  })  : assert(
          child is ListView ||
              child is SliverList ||
              child is SliverGrid ||
              child is GridView ||
              child is SliverFixedExtentList,
        ),
        super(key: key);

  @override
  _LoadMoreState createState() => _LoadMoreState();
}

class _LoadMoreState extends State<LoadMore> {
  Widget get child => widget.child;

  @override
  Widget build(BuildContext context) {
    if (child is ListView) {
      return _buildListView(child as ListView);
    } else if (child is SliverList) {
      return _buildSliverList(child as SliverList);
    } else if (child is SliverGrid) {
      return _buildSliverGrid(child as SliverGrid);
    } else if (child is GridView) {
      return _buildGridView(child as GridView);
    } else if (child is SliverFixedExtentList) {
      return _buildSliverFixedExtentList(child as SliverFixedExtentList);
    }
    return child;
  }

  Widget _buildListView(ListView listView) {
    final SliverChildDelegate delegate = listView.childrenDelegate;
    assert(delegate is SliverChildBuilderDelegate);
    if (delegate is SliverChildBuilderDelegate) {
      if (widget.isFinish || delegate.estimatedChildCount == 0) {
        return listView;
      }

      final int viewCount = delegate.estimatedChildCount! + 1;
      return ListView.custom(
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == viewCount - 1) {
              return _buildLoadMoreView();
            }
            return delegate.builder(context, index);
          },
          childCount: viewCount,
          addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
          addRepaintBoundaries: delegate.addRepaintBoundaries,
          addSemanticIndexes: delegate.addSemanticIndexes,
          findChildIndexCallback: delegate.findChildIndexCallback,
          semanticIndexOffset: delegate.semanticIndexOffset,
          semanticIndexCallback: delegate.semanticIndexCallback,
        ),
        dragStartBehavior: listView.dragStartBehavior,
        semanticChildCount: listView.semanticChildCount,
        keyboardDismissBehavior: listView.keyboardDismissBehavior,
        cacheExtent: listView.cacheExtent,
        controller: listView.controller,
        itemExtent: listView.itemExtent,
        key: listView.key,
        padding: listView.padding,
        physics: listView.physics,
        primary: listView.primary,
        reverse: listView.reverse,
        scrollDirection: listView.scrollDirection,
        shrinkWrap: listView.shrinkWrap,
      );
    }
    return listView;
  }

  Widget _buildGridView(GridView gridView) {
    final SliverChildDelegate delegate = gridView.childrenDelegate;
    assert(delegate is SliverChildBuilderDelegate);
    if (delegate is SliverChildBuilderDelegate) {
      if (widget.isFinish || delegate.estimatedChildCount == 0) {
        return gridView;
      }

      final int viewCount = delegate.estimatedChildCount! + 1;
      return GridView.builder(
        itemCount: viewCount,
        itemBuilder: (context, index) {
          if (index == viewCount - 1) {
            return _buildLoadMoreView();
          }
          return delegate.builder(context, index)!;
        },
        gridDelegate: gridView.gridDelegate,
        addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
        addRepaintBoundaries: delegate.addRepaintBoundaries,
        addSemanticIndexes: delegate.addSemanticIndexes,
        dragStartBehavior: gridView.dragStartBehavior,
        semanticChildCount: gridView.semanticChildCount,
        cacheExtent: gridView.cacheExtent,
        controller: gridView.controller,
        key: gridView.key,
        padding: gridView.padding,
        physics: gridView.physics,
        primary: gridView.primary,
        reverse: gridView.reverse,
        scrollDirection: gridView.scrollDirection,
        shrinkWrap: gridView.shrinkWrap,
      );
    }
    return gridView;
  }

  Widget _buildSliverList(SliverList list) {
    final SliverChildDelegate delegate = list.delegate;
    assert(delegate is SliverChildBuilderDelegate);

    if (delegate is SliverChildBuilderDelegate) {
      if (widget.isFinish || delegate.estimatedChildCount == 0) {
        return list;
      }
      final int viewCount = delegate.estimatedChildCount! + 1;

      return SliverList(
        delegate: _buildSliverDelegate(delegate, viewCount),
      );
    }
    return list;
  }

  Widget _buildSliverFixedExtentList(SliverFixedExtentList list) {
    final SliverChildDelegate delegate = list.delegate;
    assert(delegate is SliverChildBuilderDelegate);

    if (delegate is SliverChildBuilderDelegate) {
      if (widget.isFinish || delegate.estimatedChildCount == 0) {
        return list;
      }
      final viewCount = delegate.estimatedChildCount! + 1;

      return SliverFixedExtentList(
        itemExtent: list.itemExtent,
        delegate: _buildSliverDelegate(delegate, viewCount),
      );
    }
    return list;
  }

  SliverChildDelegate _buildSliverDelegate(
    SliverChildBuilderDelegate delegate,
    int viewCount,
  ) {
    return SliverChildBuilderDelegate(
      (context, index) {
        if (index == viewCount - 1) {
          return _buildLoadMoreView();
        }
        return delegate.builder(context, index);
      },
      childCount: viewCount,
      addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
      addRepaintBoundaries: delegate.addRepaintBoundaries,
      addSemanticIndexes: delegate.addSemanticIndexes,
      semanticIndexCallback: delegate.semanticIndexCallback,
      semanticIndexOffset: delegate.semanticIndexOffset,
    );
  }

  Widget _buildSliverGrid(SliverGrid grid) {
    final SliverChildDelegate delegate = grid.delegate;
    assert(delegate is SliverChildBuilderDelegate);

    if (delegate is SliverChildBuilderDelegate) {
      if (widget.isFinish || delegate.estimatedChildCount == 0) {
        return grid;
      }
      final int viewCount = delegate.estimatedChildCount! + 1;

      return SliverGrid(
        gridDelegate: grid.gridDelegate,
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == viewCount - 1) {
              return _buildLoadMoreView();
            }
            return delegate.builder(context, index);
          },
          childCount: viewCount,
          addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
          addRepaintBoundaries: delegate.addRepaintBoundaries,
          addSemanticIndexes: delegate.addSemanticIndexes,
          semanticIndexCallback: delegate.semanticIndexCallback,
          semanticIndexOffset: delegate.semanticIndexOffset,
        ),
      );
    }
    return grid;
  }

  Widget _buildLoadMoreView() {
    return LoadMoreWidget(onLoadMore: widget.onLoadMore);
  }
}

class LoadMoreWidget extends StatefulWidget {
  final LoadMoreCallback onLoadMore;

  const LoadMoreWidget({
    Key? key,
    required this.onLoadMore,
  }) : super(key: key);

  @override
  _LoadMoreWidgetState createState() => _LoadMoreWidgetState();
}

class _LoadMoreWidgetState extends State<LoadMoreWidget> {
  RequestResponse? _response;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _loadMore() async {
    final RequestResponse result = await widget.onLoadMore(context);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) setState(() => _response = result);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_response == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return _response!.when<Widget>(
      data: (data) => const SizedBox(),
      error: (error, trace) => ExceptionRetryIndicator(
        exception: error,
        retryCallback: () => widget.onLoadMore(context),
      ),
    );
    // if (_response == null) {
    //   return const CircularProgressIndicator();
    // } else if (_response!.hasError) {
    //   return ExceptionRetryIndicator(
    //     exception: _response!.exception!,
    //     retryCallback: () => widget.onLoadMore(context),
    //   );
    // } else {
    //   return const SizedBox();
    // }
  }
}

class CreationAwareLoadingIndicator extends StatefulWidget {
  final VoidCallback onCreate;

  const CreationAwareLoadingIndicator({
    required this.onCreate,
  });

  @override
  State<CreationAwareLoadingIndicator> createState() =>
      _CreationAwareLoadingIndicatorState();
}

class _CreationAwareLoadingIndicatorState
    extends State<CreationAwareLoadingIndicator> {
  @override
  void initState() {
    Future.microtask(widget.onCreate);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

class SliverChildSeparatedBuilderDelegate extends SliverChildBuilderDelegate {
  SliverChildSeparatedBuilderDelegate({
    required IndexedWidgetBuilder itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    required int childCount,
    ChildIndexGetter? findChildIndexCallback,
  }) : super(
          (context, index) {
            if (index.isEven) {
              return itemBuilder(context, index ~/ 2);
            }
            return separatorBuilder(context, index ~/ 2);
          },
          semanticIndexCallback: (widget, localIndex) {
            if (localIndex.isEven) {
              return localIndex ~/ 2;
            }
            // ignore: avoid_returning_null
            return null;
          },
          childCount: max(0, childCount * 2 - 1),
          findChildIndexCallback: findChildIndexCallback,
        );
}

typedef IndexedWidgetConsumerBuilder = Widget Function(
  BuildContext context,
  int index,
  WidgetRef watch,
);

class SliverTwoChildBuilderDelegate extends SliverChildBuilderDelegate {
  SliverTwoChildBuilderDelegate({
    required IndexedWidgetBuilder itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    required IndexedWidgetConsumerBuilder secondItemBuilder,
    required int childCount,
    Axis scrollDirection = Axis.vertical,
  }) : super(
          (context, index) {
            if (index.isEven) {
              return itemBuilder(context, index ~/ 2);
            }

            return Consumer(
              builder: (context, watch, child) {
                if (!index.isEven) {
                  return separatorBuilder(context, index ~/ 2);
                }
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: scrollDirection == Axis.vertical ? 8 : 0,
                    horizontal: scrollDirection == Axis.horizontal
                        ? 8 // constants.smallpadding
                        : 0,
                  ),
                  child: secondItemBuilder(context, index ~/ 2, watch),
                );

                // return separatorBuilder(context, index ~/ 2);
              },
            );
          },
          semanticIndexCallback: (widget, localIndex) {
            if (localIndex.isEven) {
              return localIndex ~/ 2;
            }
            // ignore: avoid_returning_null
            return null;
          },
          childCount: max(0, childCount * 2 - 1),
        );
}
