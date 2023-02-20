import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/http_constant.dart';

class DriverDatabase {

  static const ROOT = HttpConstant.url_api_add_driver;
  static const _ADD_CORRIDA_ACTION = 'ADD_DRIVER';



  // Method to add Driver to the database...
  static Future<String> addDriver(String nome_motorista, String sobrenome_motorista, String telefone_motorista, String email_motorista,
      String bi_motorista, String passaport_motorista, String password_motorista, String id_estado,) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_CORRIDA_ACTION;
      map['nome_motorista'] = nome_motorista;
      map['sobrenome_motorista'] = sobrenome_motorista;
      map['telefone_motorista'] = telefone_motorista;
      map['email_motorista'] = email_motorista;
      map['bi_motorista'] = bi_motorista;
      map['passaport_motorista'] = passaport_motorista;
      map['password_motorista'] = password_motorista;
      map['id_estado'] = id_estado;
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }


}
