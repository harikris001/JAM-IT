import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'query_viewmodel.g.dart';

@riverpod
class QueryNotifier extends _$QueryNotifier {
  @override
  String build() {
    return "";
  }

  void updateQuery(String query) {
    state = query;
  }
}
