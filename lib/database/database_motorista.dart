import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/http_constant.dart';
import '../models/model_racing.dart';

class MotoristaDatabase {

  static const ROOT = HttpConstant.url_api_add_driver;

  static const _ADD_DRIVER_ACTION = 'ADD_DRIVER';
  static const _UPDATE_DRIVER_ACTION = 'UPDATE_DRIVER';
  static const _DELETE_DRIVER_ACTION = 'DELETE_DRIVER';
  static const _GET_DRIVER_ACTION = 'GET_DRIVER';

  //*************************** GET METHODS ********************************* */

  //------------------------------- GET RACING ----------------------------- -/
  /*static Future<List<ModelRacing>> getDriver() async {
    try {
      //var map = Map<String, dynamic>();
      //map['action'] = _GET_SERVICE_ESTABLISHIMENT;
      //map['telefone'] = telefone;
      final response = await http.post(Uri.parse(ROOT), body: {
        'action' : _GET_DRIVER_ACTION,
      });
      print('getDriver Response: ${response.body}');
      if (200 == response.statusCode) {
        List<ModelRacing> list = parseResponseDriver(response.body);
        return list;
      } else {
        return List<ModelRacing>.from(<ModelRacing>[]);
      }
    } catch (e) {
      return List<ModelRacing>.from(<ModelRacing>[]);
    }
  }

  static List<ModelRacing> parseResponseDriver(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ModelRacing>((json) => ModelRacing.fromJson(json)).toList();
  }*/


//*************************** ADD METHODS *********************************** */

  // Method to add driver to the database...
  static Future<String> addDriver(String nome_motorista,String sobrenome_motorista, String telefone_motorista,
  String email_motorista, String bi_motorista, String passaport_motorista, String password_motorista, String id_estado) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_DRIVER_ACTION;
      map['nome_motorista'] = nome_motorista;
      map['sobrenome_motorista'] = sobrenome_motorista;
      map['telefone_motorista'] = telefone_motorista;
      map['email_motorista'] = email_motorista;
      map['bi_motorista'] = bi_motorista;
      map['passaport_motorista'] = passaport_motorista;
      map['password_motorista'] = password_motorista;
      map['id_estado'] = id_estado;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addRacing Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }



  //*************************** UPDATE METHODS ****************************** */
  // Method to update an driver in Database...
  static Future<String> updateDriver(
      String id_motorista, String nome_motorista,String sobrenome_motorista, String telefone_motorista,
      String email_motorista, String bi_motorista, String passaport_motorista, String password_motorista, String id_estado) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_DRIVER_ACTION;
      map['id_motorista'] = id_motorista;
      map['action'] = _ADD_DRIVER_ACTION;
      map['nome_motorista'] = nome_motorista;
      map['sobrenome_motorista'] = sobrenome_motorista;
      map['telefone_motorista'] = telefone_motorista;
      map['email_motorista'] = email_motorista;
      map['bi_motorista'] = bi_motorista;
      map['passaport_motorista'] = passaport_motorista;
      map['password_motorista'] = password_motorista;
      map['id_estado'] = id_estado;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updateRacing Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  //*************************** DELETE METHODS ****************************** */
  // Method to Delete an driver from Database...
  static Future<String> deleteDriver(String driverId) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_DRIVER_ACTION;
      map['driver_id'] = driverId;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('deleteDriver Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }

}
