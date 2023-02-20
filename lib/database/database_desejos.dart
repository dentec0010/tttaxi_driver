import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/http_constant.dart';

final url_api = HttpConstant.url_api_get_desejos;

class DesejosDatabase {

  final String telefone_usuario;
  DesejosDatabase({required this.telefone_usuario});


  Future getDesejos() async {
    try {
      final response = await http.post(Uri.parse(url_api), body: {
        'telefone_usuario': telefone_usuario,
      });

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result;
      } else {
        return 'Server Error';
      }
    } catch (e) {
      return 'App Error';
    }
  }

}