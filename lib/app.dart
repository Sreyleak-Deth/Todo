import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/core/routes/app_route.dart' as appRoute;
import 'package:todo_list/core/routes/app_route.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      initialRoute: appRoute.Route.TODO_LIST,
      getPages: AppPage.route,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
        );
      },
    );
  }
}
