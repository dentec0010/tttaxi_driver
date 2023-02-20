import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/http_constant.dart';

final url_api = HttpConstant.url_api_get_data_client;

class GetClientDatabase {
  final String id_cliente;

  GetClientDatabase({required this.id_cliente});

  Future getClient() async {
    try {
      final response = await http.post(Uri.parse(url_api), body: {
        'id_client': id_cliente,
      });

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        //print(result);
        return result;
      } else {
        return 'Server Error';
      }
    } catch (e) {
      return 'App Error';
    }
  }

}