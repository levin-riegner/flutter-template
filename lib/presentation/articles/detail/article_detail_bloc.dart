import 'package:flutter_template/presentation/util/base_bloc.dart';

class ArticleDetailBloc extends BaseBloc {

  final String title;
  final String url;

  ArticleDetailBloc(this.title, this.url);

  @override
  void dispose() {
  }

}