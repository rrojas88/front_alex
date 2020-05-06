import 'package:shared_preferences/shared_preferences.dart';


class Preferencias {


  static final Preferencias _instancia = new Preferencias._internal();

  factory Preferencias(){
    return _instancia;
  }
  Preferencias._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  /// Propiedades a usar en la clase
  
  get nick {
    return _prefs.getString('nick') ?? '';
  }
  set nick( String value ){
    _prefs.setString('nick', value);
  }

  get pass {
    return _prefs.getString('pass') ?? '';
  }
  set pass( String value ){
    _prefs.setString('pass', value);
  }

  get frase {
    return _prefs.getString('frase') ?? '';
  }
  set frase( String value ){
    _prefs.setString('frase', value);
  }

  get token {
    return _prefs.getString('token') ?? '';
  }
  set token( String value ){
    _prefs.setString('token', value);
  }

  get url {
    return _prefs.getString('url') ?? '';
  }
  set url( String value ){
    _prefs.setString('url', value);
  }

}

