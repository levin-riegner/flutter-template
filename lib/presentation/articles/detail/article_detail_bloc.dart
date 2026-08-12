import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:color_picker/data/article/repository/article_repository.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ArticleDetailBloc extends Cubit<String> {
  final String id;
  ArticleDetailBloc(this.id, ArticleRepository articleRepository) : super(id) {
    // Get article for id
    Flogger.i("Get article for id $id");
    articleRepository; // retained for future article lookup
  }
}
