import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login_app/user_preferences/user_preferences.dart';

class IngresoServices {
  final prefs = PreferenciasUsuario();
  final ip = "http://sistemic.udea.edu.co:4000";

  Future<bool> login(String usuario, String password) async {
    var headers = {
      'Authorization': 'Basic Zmx1dHRlci1yZXRvOnVkZWE=',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request =
        http.Request('POST', Uri.parse('$ip/reto/autenticacion/oauth/token'));
    request.bodyFields = {
      'username': usuario,
      'password': password,
      'grant_type': 'password'
    };
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      final Map<String, dynamic> decodedData =
          json.decode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        prefs.token = decodedData["access_token"];
        return true;
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print("Error");
    }
    return false;
  }

  Future<bool> register(String username, String pass, String email) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('$ip/reto/usuarios/registro/enviar'));
    request.body =
        json.encode({"username": username, "password": pass, "email": email});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      if (response.reasonPhrase == "Created") {
        return true;
      }
    }
    return false;
  }

  Future<bool> otp(String code, String username) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$ip/reto/usuarios/registro/confirmar/$username'));
    request.fields.addAll({'codigo': code});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      if (response.reasonPhrase == "Created") {
        return true;
      }
    }
    return false;
  }

  Future<List> zonas(String token) async {
    var headers = {'Authorization': 'Bearer $token', 'Cookie': 'color=rojo'};
    var request = http.Request('GET', Uri.parse('$ip/reto/zonas/zonas/listar'));

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      final List<dynamic> decodedData =
          json.decode(await response.stream.bytesToString());

      List zonas = decodedData;

      if (response.statusCode == 200) {
        print(zonas);
      } else {
        print(response.reasonPhrase);
      }
      return zonas;
    } catch (e) {
      print(e.toString());
      return ([]);
    }
  }

  Future<List> eventForZone(String token, String zona) async {
    var headers = {'Authorization': 'Bearer $token', 'Cookie': 'color=rojo'};
    var request = http.Request(
        'GET', Uri.parse('$ip/reto/events/eventos/listar/zona/$zona'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final List<dynamic> decodedData =
        json.decode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(zona);
      print(decodedData);
      return decodedData;
    } else {
      print(response.reasonPhrase);
      return ([]);
    }
  }
}
