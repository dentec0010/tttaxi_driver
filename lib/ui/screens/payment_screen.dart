import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../components/dashboard.dart';
import '../../constants/color_constant.dart';
import '../../constants/http_constant.dart';
import 'comment_screen.dart';


class PaymentScreen extends StatefulWidget {
  PaymentScreen({
    Key? key,
    required this.nome,
    required this.sobrenome,
    required this.telefone,
    required this.tipo,
    required this.origem,
    required this.destino,
    required this.valor,
    required this.telefoneMotorista,
    required this.idCorrida,
  }) : super(key: key);
  String nome;
  String sobrenome;
  String telefone;
  String tipo;
  String origem;
  String destino;
  String valor;
  String telefoneMotorista;
  String idCorrida;
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {


  static const ROOTT = HttpConstant.url_update_running_finish;

  double _maxfont(double value, double max) {
    if (value < max) {
      return value;
    } else {
      return max;
    }
  }

  void editData(String id_corrida) {
    http.post(Uri.parse(ROOTT), body: {
      'id_corrida': id_corrida,
    });
  }

  //************************* WIDGET ROOT ************************ */
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size tamanhoFonte = mediaQuery.size;
    return Scaffold(
      body: Column(

          children: [

            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'PAGAMENTO',
                style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.blackColor
                ),
              ),
            ),

            //--------------------- APPBAR ---------------------- -/
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 18,),
              height: MediaQuery.of(context).size.height / 3.5,
              width: MediaQuery.of(context).size.width - 20,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                //color: ColorConstant.colorPrimary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: ColorConstant.colorClickButton),
                image: const DecorationImage(
                  image: AssetImage("assets/images/card_credit.png"),
                fit: BoxFit.fill
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 80),
                    child: Text(
                      widget.nome + ' ' + widget.sobrenome,
                      style: GoogleFonts.quicksand(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.whiteColor
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 80),
                    child: Text(
                      widget.telefone,
                      style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.whiteColor
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 80),
                    child: Text(
                      widget.valor+ ' AOA',
                      style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.whiteColor
                      ),
                    ),
                  ),

                ],
              ),
            ),


            Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Text(
                    widget.tipo,
                    style: GoogleFonts.quicksand(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.blackColor
                    ),
                  ),

                  const SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_sharp,
                        size: 20,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 1,
                      ),
                      Container(
                        width: 120,
                        child: Text(
                          widget.origem,
                          style: GoogleFonts.quicksand(
                              color: ColorConstant.blackColor,
                              fontSize: _maxfont(tamanhoFonte.width * 0.04, 12),
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_sharp,
                        size: 20,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 1,
                      ),
                      Container(
                        width: 120,
                        child: Text(
                          widget.destino,
                          style: GoogleFonts.quicksand(
                              color: ColorConstant.blackColor,
                              fontSize: _maxfont(tamanhoFonte.width * 0.04, 12),
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height / 8,),

            //--------------------- TOTAL PAYMENT ----------------- -/
            Container(
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width -10,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorConstant.colorClickButton,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: ColorConstant.colorClickButton)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        'Total',
                        style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.whiteColor
                        ),
                      ),

                      Text(
                        widget.valor+ ' AOA',
                        style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.whiteColor
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //------------------ BUTTON CANCEL & PAY -------------- -/
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                TextButton(
                  onPressed: null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: MediaQuery.of(context).size.height / 12,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Center(
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: ColorConstant.colorCancel,
                        ),
                      ),
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        'Pagamento',
                        style: GoogleFonts.quicksand(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.blackColor
                        ),
                      ),
                      content: Text(
                        'Finalizar pagamento?',
                        style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: ColorConstant.blackColor
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancelar'),
                          child: Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ColorConstant.whiteColor
                              ),
                              child: Center(
                                child: Text(
                                  'Cancelar',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstant.colorCancel
                                  ),
                                ),
                              )
                          ),
                        ),
                        TextButton(
                          onPressed: () {

                            setState(() {
                              editData(
                                widget.idCorrida,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => MenuDashboardPage(
                                    telefone: widget.telefoneMotorista,
                                    ride: false,
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
                          child: Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorConstant.colorPrimary
                              ),
                              child: Center(
                                child: Text(
                                  'OK',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstant.whiteColor
                                  ),
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),//showAlertDialog(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.colorPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: MediaQuery.of(context).size.height / 12,
                    width:  MediaQuery.of(context).size.width / 3,
                    child: Center(
                      child: Text(
                        'Finalizar',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: ColorConstant.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
    );
  }

  //********************** ITEM DETAIL RIDE ***************** */
  _itemDetailRide(){
    return Container(
      height: MediaQuery.of(context).size.height / 16,
      width: MediaQuery.of(context).size.width / 1.2,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorConstant.whiteColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: ColorConstant.whiteColor)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            'Golf-2 -> Kilamba',
            style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorConstant.blackColor
            ),
          ),

          Text(
            '1',
            style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorConstant.blackColor
            ),
          ),

          Text(
            '500,00kz',
            style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorConstant.blackColor
            ),
          ),
        ],
      ),
    );
  }
}
