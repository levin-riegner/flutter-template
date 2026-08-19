import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ArticleDetailBloc extends Cubit<String> {
  final String id;
  final ArticleRepository _articleRepository;
  ArticleDetailBloc(this.id, this._articleRepository) : super(id) {
    // Get article for id
    Flogger.i("Get article for id $id");
  }
}
