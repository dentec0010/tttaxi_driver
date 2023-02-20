import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tttaxi_driver/ui/screens/home_screen.dart';
import 'package:tttaxi_driver/constants/loader_constant.dart';
import 'package:tttaxi_driver/ui/widgets/image_logo_widget.dart';

import '../../components/dashboard.dart';
import '../../constants/color_constant.dart';


class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key, required this.telefone}) : super(key: key);
  String telefone;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(const Duration(seconds: 6)).then((_){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MenuDashboardPage(
        telefone: widget.telefone,
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
      )));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const ImageLogoWidget(),

            const SizedBox(height: 20,),

            Text(
              'Bem-Vindo',
              style: GoogleFonts.quicksand(
                  color: ColorConstant.blackColor,
                  fontSize: 32,
                  fontWeight: FontWeight.normal
              ),
            ),

            Text(
              'ao',
              style: GoogleFonts.quicksand(
                  color: ColorConstant.blackColor,
                  fontSize: 32,
                  fontWeight: FontWeight.normal
              ),
            ),

            Text(
              'T-T TÁXI',
              style: GoogleFonts.quicksand(
                  color: ColorConstant.blackColor,
                  fontSize: 32,
                  fontWeight: FontWeight.normal
              ),
            ),

            const SizedBox(height: 20,),

            LoaderConstant(),
            
          ],
        ),
      ),
    );
  }
}
