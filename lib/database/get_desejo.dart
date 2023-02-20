import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/http_constant.dart';

final url_api = HttpConstant.url_api_get_data_desejos;

class GetDesejoDatabase {
  final String id_desejo;

  GetDesejoDatabase({required this.id_desejo});

  Future getDesejo() async {
    try {
      final response = await http.post(Uri.parse(url_api), body: {
        'id_desejos': id_desejo,
      });

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print(result);
        return result;
      } else {
        return 'Server Error';
      }
    } catch (e) {
      return 'App Error';
    }
  }

}