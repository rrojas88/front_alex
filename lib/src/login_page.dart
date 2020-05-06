
import 'package:flutter/material.dart';

import 'dart:io';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:front_alex/src/preferencias.dart';
import 'package:front_alex/src/config.dart';


class LoginPage extends StatefulWidget {
  //LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _nickCTRL = new TextEditingController();
  TextEditingController _passCTRL = new TextEditingController();
  TextEditingController _fraseCTRL = new TextEditingController();
  TextEditingController _urlCTRL = new TextEditingController();

  String _nick = '';
  String _pass = '';
  String _frase = '';
  String _url = '';

  String _nick_helper = '';
  String _pass_helper = '';
  String _frase_helper = '';

  String _msgServer = '';
  double _msgPadding = 0.0;
  double _msgAncho = 0.0;


  final prefs = new Preferencias();

  Future<bool> _presionoSalir (){
    return showDialog(
      context: context,
      builder: ( BuildContext context ){
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text('Quieres salir de la App ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.of(context).pop( false )
            ),
            FlatButton(
              child: Text('Salir'),
              //onPressed: () => Navigator.of(context).pop( true )
              onPressed: () => exit(0)
            ),
          ],
        );
      }
    );
  }


  @override
  void initState(){
    super.initState();

    _nick = prefs.nick;
    _nickCTRL.text = _nick;

    _pass = prefs.pass;
    _passCTRL.text = _pass;

    _frase = prefs.frase;
    _fraseCTRL.text = _frase;

    _url = prefs.url;
    _urlCTRL.text = _url;

    setState(() {  });
  }

  @override
  Widget build(BuildContext context) {

    /// Tambien usar el plugin: https://pub.dev/packages/back_button_interceptor

    return WillPopScope(
      onWillPop: _presionoSalir,

      child: Scaffold(
        /*appBar: AppBar(
          title: Text('Login'),
        ),*/
        body: Stack(
          children: <Widget>[
            _crearFondo( context ),
            _crearFormLogin( context ),
            SizedBox( height: 60.0 )
          ],
        ),
      ),
    );
  }


  Widget _crearFormLogin(BuildContext context ){

    final size = MediaQuery.of( context ).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 180.0,
            )
          ),

          Container(
            width: size.width * 0.85,

            margin: EdgeInsets.symmetric( vertical: 30.0),
            padding: EdgeInsets.symmetric( vertical: 50.0),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,

              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                //Icon( Icons.assignment, size: 40.0, color: Colors.green ),
                _creaBotonConfiguracion( context ),
                SizedBox( height: 30.0 ),

                Text(
                   'ACCESO',
                   style: TextStyle(
                     fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.green
                   ),
                ),

                SizedBox( height: 40.0 ),

                _crearNick(),

                _crearPass(),

                _crearFrase(),

                SizedBox( height: 30.0 ),

                _crearRespuesta( context ),

                _crearBoton( context )
                
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _creaBotonConfiguracion(BuildContext context){
    return RaisedButton.icon(
      icon: Icon( Icons.settings, size: 30.0 ),
      label: Text('Servidor'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.green,
      textColor: Colors.white,
      onPressed: ( ) { 
        _modalServer( context );
      }
    ); 
  }

  Widget _crearNick(){
    return Container(
      padding: EdgeInsets.symmetric( horizontal: 20.0 ),

      child: TextField(
        controller: _nickCTRL,
        //autofocus: true,

        cursorColor: Colors.green,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:Colors.green
            )
          ),

          hintText: 'Nick',
          labelText: 'Nick',
          labelStyle: TextStyle( color: Colors.green ),
          helperText: _nick_helper,//Ingresa tu nick',
          // Derecha
          icon: Icon( Icons.accessibility, color: Colors.green ),
          //Izquierda
          //suffixIcon: Icon(Icons.accessibility)
        ),
        onChanged: (valor){
          _nick = valor;

        },
      )
    );
  }

  Widget _crearPass(){
    return Container(
      padding: EdgeInsets.symmetric( horizontal: 20.0, vertical: 10.0 ),

      child: TextField(
        controller: _passCTRL,
        obscureText: true,

        cursorColor: Colors.green,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:Colors.green
            )
          ),

          hintText: '',
          labelText: 'Contraseña',
          labelStyle: TextStyle( color: Colors.green ),
          helperText: _pass_helper,//'Ingresa tu contraseña',
          // Derecha
          icon: Icon( Icons.https, color: Colors.green ),
        ),
        onChanged: (valor){
          _pass = valor;

        },
      ),
    );
  }

  Widget _crearFrase(){

    return Container(
      padding: EdgeInsets.symmetric( horizontal: 20.0 ),

      child: TextField(
        controller: _fraseCTRL,

        cursorColor: Colors.green,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:Colors.green
            )
          ),

          hintText: '',
          labelText: 'Frase de seguridad',
          labelStyle: TextStyle( color: Colors.green ),
          helperText: _frase_helper,//Ingresa tu nick',
          // Derecha
          icon: Icon( Icons.no_encryption, color: Colors.green ),
        ),
        onChanged: (valor){
          _frase = valor;

        },
      )
    );
  }

  Widget _crearRespuesta(BuildContext context){

    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      width: _msgAncho,
      padding: EdgeInsets.symmetric(
        horizontal: _msgPadding, vertical: _msgPadding
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(250, 132, 132, 1.0),
        borderRadius: BorderRadius.circular(6.0)
      ),
      
      //color: Colors.yellow,
      child: Text(
        _msgServer,
        style: TextStyle( color: Colors.white )
      ),
    );
  }

  Widget _crearBoton( BuildContext context ){

    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
        child: Text('Ingresar',
          style: TextStyle( fontSize: 20.0, color: Colors.white ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0)
      ),
      elevation: 0.0,

      color: Colors.green,
      textColor: Colors.white,

      onPressed: (){

        _validateData( context );
      },
    );
  }


  Widget _crearFondo(BuildContext context ){

    final size = MediaQuery.of( context ).size;

    final fondoColor = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(42, 194, 11, 1.0),
            Color.fromRGBO(10, 145, 15, 1.0),
          ] 
        )
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.3)
      ),
    );

    return Stack(
      children: <Widget>[
        fondoColor,

        Positioned(
          top: 90.0,
          left: 30.0,
          child: circulo
        ),
        Positioned(
          top: 30.0,
          right: 30.0,
          child: circulo
        ),
        Positioned(
          bottom: -20.0,
          right: 30.0,
          child: circulo
        ),

        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.message, 
                color: Colors.white, size: 100.0
              ), 
              SizedBox( height: 20.0, width: double.infinity,), 
              Text('MIS MENSAJES',
                style: TextStyle( fontSize: 26.0, color: Colors.white ),
              )
            ],
          ),
        )
      ],
    );

  }


  void _validateData( BuildContext context ) async {

    bool error = false;

    if( _nick == null  || _nick.trim() == ''){
      _nick_helper = 'Por favor ingresa el Nick';
      error = true;
    }
    else _nick_helper = '';
    print('Inicial Nick= $_nick');

    if( _pass == null ||  _pass.trim() == '' ){
      _pass_helper = 'Por favor ingresa la contraseña';
      error = true;
    }
    else _pass_helper = '';

    if( _frase == null || _frase.trim() == '' ){
      _frase_helper = 'Por favor ingresa la frase';
      error = true;
    }
    else _frase_helper = '';

    setState(() {  });


    if( error == false )
    {
      final size = MediaQuery.of( context ).size;
      _verMensaje( size.width * 0.5, 10.0, 'Comprobando.. por favor espere..');

      try {
        String url_base = _url + config['url_base'];

        var uriResponse = await http.post('$url_base/users/login',
          body: {
            'nick': _nick, 
            'pass': _pass,
            'key_app': statico['key'],
            'key_device': _frase,
        });
        
        //print('Codigo Status = ${uriResponse.statusCode}');
        print('Body = ${uriResponse.body}');
        Map responMap = json.decode( uriResponse.body );
        print(responMap);
        bool errorResponse = responMap['error'];
        
        if( errorResponse )
        {
          String msg_errors = '';
          List messages = responMap['messages'];
          messages.forEach( (msg) {
            msg_errors += msg + '\n';
          });
      
          _verMensaje(size.width * 0.8, 10.0, msg_errors);
        }
        else{
          _verMensaje( 0.0, 0.0, '');
          print('Token = ' + responMap['data']['tk']);
          /// Almacenado Local:
          prefs.nick = _nick;
          prefs.pass = _pass;
          prefs.frase = _frase;
          prefs.token = responMap['data']['tk'];

          /// Todo OK
          Navigator.pushNamed(context, '/mensajes' );
          
        }

      } catch ( err ) {
        print('Error en el AJAX');
        print( err );

        _verMensaje(size.width * 0.8, 10.0, err.toString() );
      }
    }
    else{
      print('Hay errores');
      final size = MediaQuery.of( context ).size;
      
      _verMensaje(size.width * 0.8, 10.0, 'Por favor ingrese todos los campos');
    }

  }


  void _verMensaje(double ancho, double padding, String mensaje)
  { 
    _msgAncho = ancho;
    _msgPadding = padding;
    _msgServer = mensaje;

    setState(() {  });
  }


  Future<bool>  _modalServer(BuildContext context){

    return showDialog(
      context: context,
      builder: ( BuildContext context ){
        return AlertDialog(
          title: Text('Configurar Servidor'),
          //content: Text('URL'),
          actions: <Widget>[
            _crearUrl( context ),
            SizedBox( height: 30.0 ),
            Center(
              child: FlatButton(
                child: Text('Guardar'),
                onPressed: () {
                  prefs.url = _url;

                  Navigator.of(context).pop( false );
                }
              ),
            ),
            SizedBox( height: 30.0 ),
            Center(
              child: FlatButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop( false )
              ),
            ),
            SizedBox( height: 30.0 )
          ],
        );
      }
    );
  }

  Widget _crearUrl( BuildContext context ){
    final size = MediaQuery.of( context ).size;
    return Container(
      padding: EdgeInsets.symmetric( horizontal: 20.0 ),
      width: size.width * 0.8,
      child: TextField(
        controller: _urlCTRL,

        cursorColor: Colors.green,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:Colors.green
            ),
          ),
          labelText: 'URL',
          labelStyle: TextStyle( color: Colors.green )
        ),
        onChanged: (valor){
          _url = valor;
        },
      )
    );
  }


}