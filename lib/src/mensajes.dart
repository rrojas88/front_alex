import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

import 'package:front_alex/src/preferencias.dart';
import 'package:front_alex/src/config.dart';
import 'package:front_alex/src/static.dart';


class MensajesPage extends StatefulWidget {
  //MensajesPage({Key key}) : super(key: key);

  @override
  _MensajesPageState createState() => _MensajesPageState();
}

class _MensajesPageState extends State<MensajesPage> {

  final prefs = new Preferencias();
  final FlutterTts flutterTts = FlutterTts();

  double _porcAltoMensajes = 0.7;
  double _porcAnchoMensajes = 0.7;

  /// Lista de Mensajes
  List<dynamic> _mensajes = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MIS MENSAJES'),
        centerTitle: true,

        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color.fromRGBO(42, 194, 11, 1.0),
                Color.fromRGBO(10, 145, 15, 1.0),
              ] 
            )          
          ), 
        ),
      ),
      body: _crearCuerpoPagina( context )
      //body: _crearCardsMesajes( context )
    );
  }


  Widget _crearCuerpoPagina( BuildContext context ){

    final size = MediaQuery.of( context ).size;
    double altoMensajes = size.height * _porcAltoMensajes;
    double anchoMensajes = size.width * _porcAnchoMensajes;
    
    double porcAnchoIzqDer = (1.0-_porcAnchoMensajes)/2;
    double margeIzqDer = size.width * porcAnchoIzqDer;
    

    final fondoColor = Container(
      height: altoMensajes,
      width: anchoMensajes,
      margin: EdgeInsets.only( left: margeIzqDer),
      decoration: BoxDecoration(
        
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(42, 194, 11, 1.0),
            Color.fromRGBO(10, 145, 15, 1.0),
          ] 
        )
        //color: Colors.green
      ),
    );

    return Container(
      child: Column(
        children: <Widget>[

          SizedBox( height: 20.0),

          _crearBotonConsultar(),

          Divider(), // Centra todoo
          SizedBox( height: 1.0),

          Stack(
            children: <Widget>[
              fondoColor,
              _crearCardsMesajes( context ),
            ],
          )

        ],
      ),
    );

  }


  Widget _crearBotonConsultar(){
    return RaisedButton(
      child: Container(
        //margin: EdgeInsets.only(left: 20.0 ),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Text('Tengo mensajes por leer ?',
          style: TextStyle( fontSize: 18.0, color: Colors.white ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0)
      ),
      elevation: 0.0,
      color: Colors.green,
      textColor: Colors.white,
      onPressed: (){
        _consultarMensajes( context );
      },
    );
  }


  void _consultarMensajes( BuildContext context ) async {

    try {
      String url_base = config['url_base'];

      Map<String, String> headers = {
        "token": prefs.token
      };

      var uriResponse = await http.post('$url_base/messages/get-all-my',
        headers: headers,
        body: { 
          'key_app': statico['key'],
          'key_device': prefs.frase,
      });
      
      Map responMap = json.decode( uriResponse.body );
      //print(responMap);
      bool errorResponse = responMap['error'];
      
      if( errorResponse )
      {
        String msg_errors = '';
        String salto = '\n';
        List messages = responMap['messages'];
        messages.forEach( (msg) {
          msg_errors += msg + salto;
        });
    
        _mostrarError( msg_errors, context );
      }
      else{
        //print('Cargar Lista de Mensajes !!!!!!!!!!!!!!!!!!!!!!!!');
        
        _mensajes = responMap['data'];

        _crearCardsMesajes( context );
      }

    } catch ( err ) {
      print('Error en el AJAX');
      print( err );

      _mostrarError( err.toString(), context );
    }
  }


  void _mostrarError( String mensajeError, BuildContext context ){
    print('\n +++++++++++++++++++++++++++++++++');
    print('Error');
    print('"$mensajeError"');
    String salto = '\n';
    _mensajes = [];

    bool sacar = false;
    if( mensajeError == 'Error validando el token: jwt expired'+salto ){
      sacar = true;
      mensajeError = 'Debes volver a ingresar';
    }

    Map <String, dynamic> sinMensajes = {
      'id'           : '-1',
      'createdat'    : 'Hoy',
      'message'      : mensajeError,
    };
    _mensajes.add( sinMensajes );

    setState(() {  });

    
    if( sacar ){
      final duration = new Duration( seconds: 3 );
      new Timer( duration, () {
        Navigator.pop(context);
      });;
    }
  }


  Widget _crearCardsMesajes( BuildContext context ) {

    setState(() {  });

    final size = MediaQuery.of( context ).size;
    double altoMensajes = size.height * _porcAltoMensajes;

    if( _mensajes.length == 0 )
    {
      Map <String, dynamic> sinMensajes = {
        'id'           : '-1',
        'createdat'    : 'Hoy',
        'message'      : 'No hay mensajes.. revisa mas tarde',
      };
      _mensajes.add( sinMensajes );
    }

    return Container(
      height: altoMensajes,
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: _mensajes.length,
        itemBuilder: (BuildContext context, int index ){

          final mensaje = _mensajes[ index ];
          print('.........................');
          print(mensaje);
          print('.........................');

          String fecha = mensaje['createdat'];
          String msg = mensaje['message'];

          if( mensaje['id'] != '-1' )
          {
            List vFechaHora = fecha.split('T');
            List vFecha = vFechaHora[0].split('-');
            String dia = vFecha[2]+'-'+vFecha[1]+'-'+vFecha[0];

            List vHoraZ = vFechaHora[1].split('Z');
            String hora = vHoraZ[0];
            hora = hora.substring(0, 8);

            fecha = ' el '+dia+ ' a las ' + hora;
          }

          return _crearCardParaMensaje( 
            context, 
            fecha, 
            msg,  
            mensaje['id'], 
            mensaje, 
            index
          );

        },
      ),
    );
  }


  Widget _crearCardParaMensaje( BuildContext context, String fecha, String mensaje, String id, dynamic info, int indexMensaje ) {

    final btnBorrar = FlatButton(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_outline),
            tooltip: 'Borrar',
            onPressed: () {
              _confirmarBorrar( context, info, indexMensaje );
            },
          ),
          Text('Eliminar'),
        ],
      ),
      onPressed: () {
        _confirmarBorrar( context, info, indexMensaje );
      },
    );

    final btnReproducir = FlatButton(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.volume_up),
            tooltip: 'Play',
            onPressed: () {
              _reproducir( mensaje );
            },
          ),
          Text('Reproducir'),
        ],
      ),
      onPressed: () {
        _reproducir( mensaje );
      },
    );

    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon( Icons.message, color: Colors.green ),
            subtitle: Text('Mensaje creado: $fecha'),
            //title: Text('Mensaje creado: $fecha'),
            title: Container(
              padding: EdgeInsets.only( top: 10.0, bottom: 10.0 ),
              child: Text(
                mensaje,

                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.green,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Divider(),

              ( id != '-1' ) ? btnBorrar : Container(),
              ( id != '-1' ) ? btnReproducir : Container(),

              Divider()
            ],
          )
        ],
      ),
    );

  }


  void _confirmarBorrar(BuildContext context, dynamic mensaje, int indexMensaje ) {

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {

        return AlertDialog(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
          title: Text('Segur@ ?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Estás seguro de borrar el mensaje ?'),
              //FlutterLogo( size: 100.0 )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: ()=> Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: (){
                Navigator.of(context).pop();

                _borrar( mensaje, context, indexMensaje );
              },
            ),
          ],
        );

      }
    );
  }

  void _borrar( dynamic mensaje, BuildContext context, int indexMensaje ) async {

    try {
      print(' .................... Borrando mensaje ..................... ');
      String url_base = config['url_base'];

      Map<String, String> headers = {
        "token": prefs.token
      };

      var uriResponse = await http.post('$url_base/messages/update',
        headers: headers,
        body: {
          'id': mensaje['id'],
          'target': mensaje['target'],
          'message': mensaje['message'],
          'new_': 'false',
          'key_app': statico['key'],
          'key_device': prefs.frase,
      });
      
      Map responMap = json.decode( uriResponse.body );
      print('=========== Resultado del Server =========');
      print(responMap);
      bool errorResponse = responMap['error'];
      
      if( errorResponse )
      {
        String msg_errors = '';
        String salto = '\n';
        List messages = responMap['messages'];
        messages.forEach( (msg) {
          msg_errors += msg + salto;
        });
    
        _mostrarError( msg_errors, context );
      }
      else{
        print('Cargar Nuevamente la Lista de Mensajes !!!!!!!!!!!!!!!!!!!!!!!!');
        
        _mensajes.removeAt(indexMensaje);

        setState(() {  });
      }

    } catch ( err ) {
      print('Error en el AJAX');
      print( err );

      _mostrarError( err.toString(), context );
    }
  }


  Future _reproducir( String texto ) async {

    //texto.replace(/[^a-zA-Z\d\-\_\.\,áéíóúÁÉÍÓÚÑñ]/g, 'x');

     String textoOK = texto.replaceAll(new RegExp(r"[^a-zA-Z\d\-\_\.\,áéíóúÁÉÍÓÚÑñ\s]"), '');

     print('====== TEXTO LIMIPIO ======');
     print(textoOK);

    await flutterTts.setLanguage("es-ES");
    //await flutterTts.setLanguage("es-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.isLanguageAvailable("es-ES");

    var result = await flutterTts.speak( textoOK );
    if( result == 1 ){
      print('Ha hablado OK');
    }

  }



  


}