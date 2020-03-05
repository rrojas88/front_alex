import 'package:flutter/material.dart';


import 'package:front_alex/src/login_page.dart';
import 'package:front_alex/src/mensajes.dart';

Map <String, WidgetBuilder> getApplicationRoutes(){
  return <String, WidgetBuilder>{
    '/login'         : ( BuildContext context ) => LoginPage(),
    '/mensajes'      : ( BuildContext context ) => MensajesPage()

  };
}
