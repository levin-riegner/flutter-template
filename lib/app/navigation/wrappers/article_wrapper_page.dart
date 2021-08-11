import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/presentation/articles/articles_bloc.dart';
import 'package:flutter_template/presentation/articles/detail/article_detail_bloc.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:provider/provider.dart';

class ArticleWrapperPage extends StatelessWidget {
  ArticleWrapperPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ArticlesBloc>(
          create: (context) => ArticlesBloc(
            getIt<ArticleRepository>(),
          ),
          dispose: (context, bloc) => bloc.dispose(),
        ),
        Provider<ArticleDetailBloc>(
          create: (context) => ArticleDetailBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        )
      ],
      child: AutoRouter(),
    );
  }
}
