import 'package:flutter/material.dart';

mixin InfiniteScrolling<T extends StatefulWidget> on State<T> {
  final scrollController = ScrollController();
  int page = 1;
  int lastPageNr = 1000;
  bool canFetch = true;

  void restartInfiniteScrolling() {
    page = 1;
    lastPageNr = 1000;
    canFetch = true;
  }

  void infiniteScrollingListener({required Future<int> Function() action, num sensibility = 0.9}) async {
    assert(sensibility >= 0 && sensibility <= 1, '''

          The sensibility must be a number between 0 and 1

    ''');
    if (!canFetch) {
      return;
    }
    final offset = scrollController.offset;
    final maxScroll = scrollController.position.maxScrollExtent;
    if (offset >= maxScroll * 0.9 && page < lastPageNr) {
      page++;
      try {
        canFetch = false;
        lastPageNr = await action();
      } catch (_) {
        debugPrint('$_');
      } finally {
        canFetch = true;
      }
    }
  }
}
