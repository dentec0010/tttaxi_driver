import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/http_constant.dart';
import '../models/model_racing.dart';

class RacingDatabase {

  static const ROOT = HttpConstant.url_api_racing+'/registarCorrida.php';
  static const ROOTy = HttpConstant.url_get_corridas;

  static const _ADD_RACING_ACTION = 'ADD_RACING';
  static const _UPDATE_RACING_ACTION = 'UPDATE_RACING';
  static const _DELETE_RACING_ACTION = 'DELETE_RACING';
  static const _GET_RACING_ACTION = 'GET_CORRIDAS';

  //*************************** GET METHODS ********************************* */

  //------------------------------- GET RACING ----------------------------- -/
  /*static Future<List<ModelRacing>> getRacing() async {
    try {
      //var map = Map<String, dynamic>();
      //map['action'] = _GET_SERVICE_ESTABLISHIMENT;
      //map['telefone'] = telefone;
      final response = await http.post(Uri.parse(ROOTy), body: {
        'action' : _GET_RACING_ACTION,
      });
      print('getRacing Response: ${response.body}');
      if (200 == response.statusCode) {
        List<ModelRacing> list = parseResponseRacing(response.body);
        return list;
      } else {
        return List<ModelRacing>.from(<ModelRacing>[]);
      }
    } catch (e) {
      return List<ModelRacing>.from(<ModelRacing>[]);
    }
  }

  static List<ModelRacing> parseResponseRacing(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ModelRacing>((json) => ModelRacing.fromJson(json)).toList();
  }*/



//*************************** ADD METHODS *********************************** */

  // Method to add racing to the database...
  static Future<String> addRacing(String nome_cliente, String ponto_de_partida, String ponto_de_destino,
      String desejos_corrida, String data_da_corrida, String hora_da_corrida, String valor_corrida, String estadoDeCorrida) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_RACING_ACTION;
      map['nome_cliente'] = nome_cliente;
      map['ponto_de_partida'] = ponto_de_partida;
      map['ponto_de_destino'] = ponto_de_destino;
      map['desejos_corrida'] = desejos_corrida;
      map['data_da_corrida'] = data_da_corrida;
      map['hora_da_corrida'] = hora_da_corrida;
      map['valor_corrida'] = valor_corrida;
      map['estadoDeCorrida'] = estadoDeCorrida;
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
  // Method to update an racing in Database...
  static Future<String> updateRacing(
      String id_corrida, String nome_cliente, String ponto_de_partida, String ponto_de_destino,
      String desejos_corrida, String data_da_corrida, String hora_da_corrida, String valor_corrida, String estadoDeCorrida) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_RACING_ACTION;
      map['id_corrida'] = id_corrida;
      map['nome_cliente'] = nome_cliente;
      map['ponto_de_partida'] = ponto_de_partida;
      map['ponto_de_destino'] = ponto_de_destino;
      map['desejos_corrida'] = desejos_corrida;
      map['data_da_corrida'] = data_da_corrida;
      map['hora_da_corrida'] = hora_da_corrida;
      map['valor_corrida'] = valor_corrida;
      map['estadoDeCorrida'] = estadoDeCorrida;
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
  // Method to Delete an racing from Database...
  static Future<String> deleteRacing(String racingId) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_RACING_ACTION;
      map['Racing_id'] = racingId;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('deleteRacing Response: ${response.body}');
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
