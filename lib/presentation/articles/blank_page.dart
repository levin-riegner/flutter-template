import 'package:flutter/material.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton(
            child: const Text("Open Article"),
            onPressed: () {
              context.go(
                ArticleDetailRoute(
                  context.router,
                  id: "4321",
                  url: "https://www.levinriegner.com/home",
                ).location,
              );
            },
          ),
          FilledButton(
            child: const Text("Open Dialog"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Blank Page"),
                    content: const Text("This is a blank page."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK")),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
