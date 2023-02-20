import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color_constant.dart';
import '../../constants/http_constant.dart';
import '../../database/get_client.dart';
import '../../database/get_desejo.dart';
import 'comment_screen.dart';
import 'package:http/http.dart' as http;


class RidersScreen extends StatefulWidget {
  RidersScreen({Key? key, required this.motorista}) : super(key: key);

  String motorista;

  @override
  State<RidersScreen> createState() => _RidersScreenState();
}

class _RidersScreenState extends State<RidersScreen> {

  static const ROOT = HttpConstant.url_get_running_driver;
  String id_desejos = '';
  String desejo_corrida = '';


  String nome_cli = '';
  String sobrenome_cli = '';
  String telefone_cli = '';
  String password_cli = '';
  String id_estado_cli = '';

  @override
  void initState() {
    super.initState();
    getRacing();

  }




  Future<List> getRacing() async{
    final responce = await http.post(Uri.parse(ROOT), body: {
    'telefone_motorista': widget.motorista,
    });
    return jsonDecode(responce.body);
  }

  //************************* WIDGET ROOT ************************ */
  @override
  Widget build(BuildContext context) {

    /*Timer(Duration(seconds: 1), () => setState((){

    }));*/
    /*GetClientDatabase(id_cliente: desejo_corrida).getClient().then((value) {
      nome_cli = value[0]['nome_usuario'];
      sobrenome_cli = value[0]['sobrenome_usuario'];
      telefone_cli = value[0]['telefone_usuario'];
      setState(() {});
    });*/
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: ColorConstant.transparent,
        //border: Border.all(width: 1, color: Colors.black38),
      ),
      child: FutureBuilder<List>(
        future: getRacing(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            print("error");
          }
          if(snapshot.hasData){
            //ListRacing(list: snapshot.data as List);
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.hasData == null ? 0 : snapshot.data!.length,
              padding: EdgeInsets.only(left: 10),
              itemBuilder: (context, index){
                desejo_corrida = snapshot.data![index]['id_cliente_corrida'];
                return snapshot.hasData == 0 ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('Não existe nenhuma corrida Aceite.'),

                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )
                      ),
                    ],
                  ),
                ) : _clientDataRideAcept( snapshot.data![index]['nome_usuario'],
                    snapshot.data![index]['telefone_usuario'],snapshot.data![index]['ponto_partida'],
                    snapshot.data![index]['ponto_destino'], snapshot.data![index]['valor_total_corrida'], snapshot.data![index]['data_corrida']);
              },
            );
          }
          return Container(
            height: 40,
            width: 40,
            child: Center(child: CircularProgressIndicator())
          );
        },
      ),
    );
  }


  //********************* CLIENT DATA RIDE ACEPT ************************ */
  _clientDataRideAcept(String nome, String telf, String ponto_origem, String ponto_destino, String valor, String data){

    return Column(
      children: [

        //::::::::::::::::::::: CLIENT :::::::::::::::::::::: :/
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      nome,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: ColorConstant.blackColor,
                      ),
                    ),

                    //------------------- SPACE -------------------- -/


                    Text(
                      telf,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: ColorConstant.blackColor,
                      ),
                    ),

                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      width: 150,
                      child: Text(
                        ponto_origem,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: ColorConstant.blackColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    //------------------- SPACE -------------------- -/


                    Container(
                      width: 150,
                      child: Text(
                        ponto_destino,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: ColorConstant.blackColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  ],
                ),

                //-------------------- PRICE ---------------------- -/
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      valor +' AOA',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: ColorConstant.blackColor,
                      ),
                    ),

                    Container(
                      width: 100,
                      child: Center(
                        child: Text(
                          data,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: ColorConstant.blackColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ),

      ],
    );
  }

}
