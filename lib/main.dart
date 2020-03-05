import 'package:flutter/material.dart';
import 'package:front_alex/src/preferencias.dart';

import 'package:front_alex/src/routes.dart';

import 'package:front_alex/src/NotFound404_page.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new Preferencias();
  await prefs.initPrefs();

  runApp(MyApp());

}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final prefs = new Preferencias();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'Flutter Demo',
      //home: Text('Flutter Demo Home Page'),
      initialRoute: '/login',
      routes: getApplicationRoutes(),
      onGenerateRoute: ( RouteSettings setting ){
        return MaterialPageRoute(
          builder: (BuildContext context) => NotFound404Page()
        );
      },
    );
  }

}
