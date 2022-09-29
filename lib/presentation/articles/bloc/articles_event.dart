import 'package:freezed_annotation/freezed_annotation.dart';

part 'articles_event.freezed.dart';

@freezed
class ArticlesEvent with _$ArticlesEvent {
  const factory ArticlesEvent.fetch({@Default(false) bool forceRefresh}) =
      ArticlesEventFetch;
}
