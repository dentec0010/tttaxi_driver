import'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tttaxi_driver/ui/screens/home_screen.dart';
import '../../components/dashboard.dart';
import '../../constants/color_constant.dart';
import '../../constants/http_constant.dart';

class ListRacing extends StatefulWidget {
  ListRacing({Key? key, required this.list}) : super(key: key);
  List list;

  @override
  State<ListRacing> createState() => _ListRacingState();
}

class _ListRacingState extends State<ListRacing> {

  bool aceptRide = false;
  late int indexx;
  static const ROOT = HttpConstant.url_update_running;

  @override
  void initState() {
    super.initState();
    aceptRide = false;
  }

  void editData(){
    http.post(Uri.parse(ROOT),body: {
      'id_corrida':widget.list[indexx]['id_corrida'],
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.list == null ? 0 : widget.list.length,
      padding: EdgeInsets.only(left: 10),
      itemBuilder: (context, index){

        return widget.list == null ? Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text('Não existe nenhuma corrida solicitada.'),

              SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: CircularProgressIndicator(),
                )
              ),

            ],
          ),
        ) :  InkWell(
          onTap: (){
            setState((){
              indexx = index;
            });
            showDialog(context: context, builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)), //this right here
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.6,
                  width: MediaQuery.of(context).size.width - 10,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        //--------------- TITLE ---------- -/
                        Text(
                          "Corrida Solicitada",
                          style: GoogleFonts.quicksand(
                              color: ColorConstant.blackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        const SizedBox(height: 10,),
/*
                        //-------------- PHOTO -------------- -/
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                              color: ColorConstant.whiteColor,
                              borderRadius: BorderRadius.circular(300),
                              border: Border.all(width: 1, color: Colors.black38)
                          ),
                          child: const Icon(
                            Icons.person_sharp,
                            size: 150,
                            color: ColorConstant.textColorBlack12,
                          ),
                        ),

                        const SizedBox(height: 10,),
*/
                        //--------------- NAME -------------- -/
                        Text(
                          widget.list[index]['nome_usuario'],
                          style: GoogleFonts.quicksand(
                              color: ColorConstant.blackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        const SizedBox(height: 5,),

                        //--------------- PHONE ---------------- -/
                        Text(
                          widget.list[index]['sobrenome_usuario'],
                          style: GoogleFonts.quicksand(
                              color: ColorConstant.blackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.normal
                          ),
                        ),

                        const SizedBox(height: 20,),

                        //--------------- ADRESS & TIME --------- -/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            _adressTimeItem(Icons.location_on, widget.list[index]['ponto_destino'], Colors.red),

                            _adressTimeItem(Icons.location_on, widget.list[index]['ponto_partida'], Colors.green),

                            _adressTimeItem(Icons.money, widget.list[index]['valor_total_corrida'], ColorConstant.colorPrimary),

                          ],
                        ),

                        const SizedBox(height: 20,),

                        //---------------- WISHES -------------- -/
                        Column(
                          children: [
                            _witches(widget.list[index]['descricao_desejocorrida'], "300Kz"),
                            const SizedBox(height: 20,),
                            _witches("Total", widget.list[index]['valor_total_corrida'].toString()),
                          ],
                        ),

                        const SizedBox(height: 20,),

                        //----------------- BUTTONS ------------ -/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            SizedBox(
                              width: MediaQuery.of(context).size.width / 6,
                              child: RaisedButton(
                                child: const Icon(
                                  Icons.phone,
                                  size: 15,
                                  color: ColorConstant.whiteColor,
                                ),
                                color: Colors.green,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                onPressed: () {},
                              ),
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width / 6,
                              child: RaisedButton(
                                child: const Icon(
                                  Icons.comment,
                                  size: 15,
                                  color: ColorConstant.whiteColor,
                                ),
                                color: Colors.blue,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                onPressed: () {},
                              ),
                            ),


                            SizedBox(
                              width: MediaQuery.of(context).size.width / 6,
                              child: RaisedButton(
                                child: const Icon(
                                  Icons.cancel,
                                  size: 15,
                                  color: ColorConstant.whiteColor,
                                ),
                                color: Colors.grey,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10,),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            onPressed: () {
                              //go to ride...
                              setState(() {
                                aceptRide = true;
                                editData();
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => MenuDashboardPage(
                                        telefone: widget.list[index]['nome_usuario'].toString(),
                                        ride: aceptRide,
                                      driver_arrive: false,
                                      latitude_motorista: 0,
                                      longitude_motorista: 0,
                                      latitude_destino: 0,
                                      longitude_destino: 0,
                                      nome_cliente: '',
                                      telefone_cliente: '',
                                      kilometro_corrida_cliente: '' ,
                                      preco_corrida_cliente: '',
                                      descrisao_partida_cliente: '',
                                      descrisao_chegada_cliente: '',
                                    ),
                                    //ProductPage
                                  ),
                                );
                              });
                            },
                            child: Text(
                              "Aceitar Corrida",
                              style: GoogleFonts.quicksand(
                                  color: ColorConstant.whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            color: ColorConstant.colorPrimary,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.04,
            decoration: const BoxDecoration(
              color: ColorConstant.transparent,
              //border: Border.all(width: 1, color: Colors.black38),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  widget.list[index]['ponto_partida'],
                  style: GoogleFonts.quicksand(
                      color: ColorConstant.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.normal
                  ),
                ),

                //-------------------- ICON STATE ---------------- -/
                Text(
                  widget.list[index]['ponto_destino'],
                  style: GoogleFonts.quicksand(
                      color: ColorConstant.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.normal
                  ),
                ),

                Text(
                  widget.list[index]['valor_total_corrida']+' AOA',
                  style: GoogleFonts.quicksand(
                      color: ColorConstant.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //**************** ADRESS & TIME ************* */
  _adressTimeItem(IconData iconData, String description, Color color){
    return Container(
      child: Column(

        children: [

          Icon(
            iconData,
            size: 20,
            color: color,
          ),

          Text(
            description,
            style: GoogleFonts.quicksand(
                color: ColorConstant.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }

  //****************** WITCHES ******************* */
  _witches(String description, String price){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Text(
          description,
          style: GoogleFonts.quicksand(
              color: ColorConstant.blackColor,
              fontSize: 14,
              fontWeight: FontWeight.bold
          ),
        ),

        Text(
          price,
          style: GoogleFonts.quicksand(
              color: ColorConstant.blackColor,
              fontSize: 14,
              fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
}
