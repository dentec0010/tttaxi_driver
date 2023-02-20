import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tttaxi_driver/ui/screens/profile_screen.dart';
import 'package:tttaxi_driver/ui/screens/ride_progress_screen.dart';

import '../constants/color_constant.dart';
import '../database/get_driver.dart';
import '../models/model_coord.dart';
import '../providers/location_provider.dart';
import '../services/location_service.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/onboarding_screen.dart';
import '../ui/screens/payment_screen.dart';
import '../ui/screens/require_screen.dart';
import '../ui/screens/riders_screen.dart';


final Color backgroundColor = Color(0xFF2d2d39);

class MenuDashboardPage extends StatefulWidget {
  MenuDashboardPage({
    Key? key,
    required this.telefone,
    required this.ride,
    required this.driver_arrive,
    required this.latitude_motorista,
    required this.longitude_motorista,
    required this.latitude_destino,
    required this.longitude_destino,
    required this.nome_cliente,
    required this.telefone_cliente,
    required this.kilometro_corrida_cliente,
    required this.preco_corrida_cliente,
    required this.descrisao_partida_cliente,
    required this.descrisao_chegada_cliente,
  }) : super(key: key);
  String telefone;
  bool ride;
  bool driver_arrive;
  double latitude_motorista;
  double longitude_motorista;
  double latitude_destino;
  double longitude_destino;
  String nome_cliente;
  String telefone_cliente;
  String kilometro_corrida_cliente;
  String preco_corrida_cliente;
  String descrisao_partida_cliente;
  String descrisao_chegada_cliente;

  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double? screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 200);
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  Animation<double>? _menuScaleAnimation;
  Animation<Offset>? _slideAnimation;
  double mainBorderRadius = 0;
  Brightness statusIconColor = Brightness.dark;

  String id_motorista = '';
  String nome_motorista = '';
  String sobrenome_motorista = '';
  String telefone_motorista = '';
  String email_motorista = '';
  String bi_motorista = '';
  String passaport_motorista = '';
  String password_motorista = '';
  String id_estado = '';


  bool inicio = true;
  bool corrida = false;
  bool perfil = false;
  bool configuracoes = false;
  bool sair = false;

  @override
  void initState() {
    super.initState();

    GetDriverDatabase(telefone_motorista: widget.telefone).getDriver().then((value) {
      id_motorista = value[0]['id_motorista'];
      nome_motorista = value[0]['nome_motorista'];
      sobrenome_motorista = value[0]['sobrenome_motorista'];
      telefone_motorista = value[0]['telefone_motorista'];
      email_motorista = value[0]['email_motorista'];
      bi_motorista = value[0]['bi_motorista'];
      passaport_motorista = value[0]['passaport_motorista'];
      password_motorista = value[0]['password_motorista'];
      id_estado = value[0]['id_estado'];
      setState(() {});
    });


    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.7).animate(_controller!);
    _menuScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(_controller!);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_controller!);

    inicio = true;
    corrida = false;
    perfil = false;
    configuracoes = false;
    sair = false;

  }


  @override
  void dispose() {
    _controller!.dispose();
    LocationServices().closeLocation();
    super.dispose();
  }


  //********************************** WIDGET MENU ITEM ********************* */
  Widget menuItem({
    IconData? iconData,
    String? title,
    bool active: false,
  }) {
    return SizedBox(
      width: 0.5 * screenWidth!,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 20,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Icon(
                iconData,
                color: (active) ? Colors.white : Colors.grey,
                size: 22,
              ),
            ),
            Expanded(
              flex: 14,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "$title",
                  style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: (active) ? Colors.white : Colors.grey
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //****************************** WIDGET MENU ****************************** */
  Widget menu(context,) {
    return SlideTransition(
      position: _slideAnimation!,
      child: ScaleTransition(
        scale: _menuScaleAnimation!,
        child:  Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 60),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        width: 0.3 * screenWidth!,
                        margin: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: <Widget>[
                            SizedBox(
                              height: 0.2 * screenWidth!,
                              width: 0.3 * screenWidth!,
                              child: Container(

                                alignment: Alignment.topLeft,

                                child: const CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: AssetImage("assets/images/patrao.jpg"),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nome_motorista,
                                  style: GoogleFonts.quicksand(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstant.whiteColor),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.telefone,
                                  style: GoogleFonts.quicksand(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstant.whiteColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          setState(() {
                            inicio = true;
                            corrida = false;
                            perfil = false;
                            configuracoes = false;
                            sair = false;
                            _controller!.reverse();
                            isCollapsed = !isCollapsed;
                          });
                        },
                        child: menuItem(
                          title: "Inicio",
                          iconData: Icons.home_filled,
                          active: inicio,
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          setState(() {
                            inicio = false;
                            corrida = true;
                            perfil = false;
                            configuracoes = false;
                            sair = false;
                            _controller!.reverse();
                            isCollapsed = !isCollapsed;
                          });
                        },
                        child: menuItem(
                          title: "Minhas Corridas",
                          iconData: Icons.directions_walk_sharp,
                          active: corrida,
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          setState(() {
                            inicio = false;
                            corrida = false;
                            perfil = true;
                            configuracoes = false;
                            sair = false;
                            _controller!.reverse();
                            isCollapsed = !isCollapsed;
                          });
                        },
                        child: menuItem(
                            title: "Perfil",
                            iconData: Icons.person_pin,
                            active: perfil
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      inicio = false;
                      corrida = false;
                      perfil = false;
                      configuracoes = false;
                      sair = true;
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                        const OnboardingScreen(),
                        ),
                      );
                    });
                  },
                  child: menuItem(
                    title: "Sair",
                    iconData: Icons.exit_to_app,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  //*************************** DATA ESTABLISHIMENT ************************* */
  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.5 * screenWidth!,
      width: screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation!,
        child: Material(
          borderRadius: BorderRadius.circular(mainBorderRadius),
          animationDuration: duration,
          color: Color(0xfff4faff),
          child: SafeArea(
              child: Stack(
                children: <Widget>[
                  ListView(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                          top: 5,
                          bottom: 0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isCollapsed ? Icons.drag_handle : Icons.arrow_back ,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (isCollapsed) {
                                          mainBorderRadius = 0;
                                          statusIconColor = Brightness.light;
                                          _controller!.forward();
                                        } else {
                                          _controller!.reverse();
                                          mainBorderRadius = 0;
                                          statusIconColor = Brightness.dark;
                                        }
                                        isCollapsed = !isCollapsed;
                                      });
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'T-T Táxi',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: ColorConstant.blackColor
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //---------------------- MENUS ------------------------ -/
                      widget.driver_arrive ? RideProgressScreen(
                          latitude_motorista: widget.latitude_motorista,
                          longitude_motorista: widget.longitude_motorista,
                          latitude_destino_cliente: widget.latitude_destino,
                          longitude_destino_cliente: widget.longitude_destino,
                        nome_cliente: widget.nome_cliente,
                        telefone_cliente: widget.telefone_cliente,
                        kilometro_corrida_cliente: widget.kilometro_corrida_cliente,
                        preco_corrida_cliente: widget.preco_corrida_cliente,
                        descrisao_partida_cliente: widget.descrisao_partida_cliente,
                        descrisao_chegada_cliente: widget.descrisao_chegada_cliente,
                      ) :
                      inicio && !widget.driver_arrive ? HomeScreen(
                        ride: widget.ride,
                        id_motorista: id_motorista,
                        telefone_motorista: widget.telefone,
                      ):
                      corrida ? //RequireScreen() :
                      RidersScreen(motorista: id_motorista,) :
                      perfil ? ScreenProfile(
                          id_motorista: id_motorista,
                          nome_motorista: nome_motorista,
                          sobrenome_motorista: sobrenome_motorista,
                          telefone_motorista: telefone_motorista,
                          email_motorista: email_motorista,
                          bi_motorista: bi_motorista,
                          passaport_motorista: passaport_motorista,
                          password_motorista: password_motorista
                      ) : Container(),
                    ],
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

  //**************************** WIDGET ROOT ******************************** */
  @override
  Widget build(BuildContext context) {
    var locationProvider = Provider.of<LocationProvider>(context);
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: statusIconColor,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Color(0xff343442),
      body: StreamProvider<UserLocation>(
          initialData: locationProvider.userLocation,
          create: (context) => LocationServices().locationStream,
          child: Stack(
            children: [
              menu(context),
              dashboard(context),
            ],
          ),
      ),
    ) /* : const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    )*/;
  }
}