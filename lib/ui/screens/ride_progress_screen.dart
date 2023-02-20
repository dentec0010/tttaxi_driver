import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tttaxi_driver/constants/color_constant.dart';
import 'package:tttaxi_driver/constants/loader_min_constant.dart';
import 'package:tttaxi_driver/ui/screens/payment_screen.dart';
import 'package:url_launcher/url_launcher.dart';


class RideProgressScreen extends StatefulWidget {
  RideProgressScreen({
    Key? key,
    required this.latitude_motorista,
    required this.longitude_motorista,
    required this.latitude_destino_cliente,
    required this.longitude_destino_cliente,
    required this.nome_cliente,
    required this.telefone_cliente,
    required this.kilometro_corrida_cliente,
    required this.preco_corrida_cliente,
    required this.descrisao_partida_cliente,
    required this.descrisao_chegada_cliente,
  }) : super(key: key);
  double latitude_motorista;
  double longitude_motorista;
  double latitude_destino_cliente;
  double longitude_destino_cliente;
  String nome_cliente;
  String telefone_cliente;
  String kilometro_corrida_cliente;
  String preco_corrida_cliente;
  String descrisao_partida_cliente;
  String descrisao_chegada_cliente;
  @override
  State<RideProgressScreen> createState() => _RideProgressScreenState();
}

const kGoogleApiKey = 'AIzaSyDnS-LAt0PZd0KgnpBrE24LMjhmMCk4tWE';
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final homeScaffoldKeyD = GlobalKey<ScaffoldState>();

class _RideProgressScreenState extends State<RideProgressScreen> {



  Set<Marker> _markers = Set();
  Map<PolylineId, Polyline> polylines = {};
  GoogleMapController? mapController; //controller for Google map
  List<LatLng> polylineCoordinatess = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double distance = 0.0;
  double distanceClientDestiny = 0;



  @override
  void initState() {
    super.initState();
    getDirections(widget.latitude_motorista, widget.longitude_motorista, widget.latitude_destino_cliente, widget.longitude_destino_cliente);
  }



  //------------------- METHOD MAP -------------------- -/
  getDirections(double lat_cliente, double log_cliente, double lat_motorista, double log_motorista) async {

    BitmapDescriptor markerbitmaps = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/stopy.png",
    );

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(lat_cliente, log_cliente),
      PointLatLng(lat_motorista, log_motorista),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinatess.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinatess.length - 1; i++) {
      totalDistance += calculateDistanceClienteDestino(
          polylineCoordinatess[i].latitude,
          polylineCoordinatess[i].longitude,
          polylineCoordinatess[i + 1].latitude,
          polylineCoordinatess[i + 1].longitude);
    }

    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId("1"),
        position: LatLng(lat_motorista, log_motorista),
        infoWindow: const InfoWindow(title: 'Destino'),
        icon: markerbitmaps,
      ));
      /*mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat_motorista, log_motorista), zoom: 18)
          //17 is new zoom level
          ));*/
      distance = totalDistance;
    });
    addPolyLine(polylineCoordinatess);
  }


  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.lightBlue,
      points: polylineCoordinates,
      width: 4,
    );

    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistanceClienteDestino(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }


  //********************* CLIENT DATA RIDE ACEPT ************************ */
  _clientDataRideAcept() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.5,
      //padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: ColorConstant.whiteColor,
        //border: Border.all(width: 1, color: Colors.black38),
      ),
      child: Column(
        children: [
          //::::::::::::::::::::: CLIENT :::::::::::::::::::::: :/
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //------------------- PHOTO CLIENT -------------------- -/
                  Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width / 5,
                        decoration: BoxDecoration(
                          color: ColorConstant.whiteColor,
                          borderRadius: BorderRadius.circular(300),
                          border:
                          Border.all(width: 1, color: Colors.transparent),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/client_locations.png"),
                              fit: BoxFit.fill),
                        ),
                      ),

                      //------------------- SPACE -------------------- -/
                      const SizedBox(
                        width: 10,
                      ),

                      //----------------------- CLIENT NAME --------------------- -/
                      Column(
                        children: [
                          Text(
                            widget.nome_cliente,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: ColorConstant.blackColor,
                            ),
                          ),

                          //------------------- SPACE -------------------- -/

                          Text(
                            widget.telefone_cliente,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: ColorConstant.blackColor,
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),

                  //-------------------- PRICE ---------------------- -/
                  Column(
                    children: [
                      Text(
                        widget.preco_corrida_cliente + ' AOA',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: ColorConstant.blackColor,
                        ),
                      ),
                      Text(
                        widget.kilometro_corrida_cliente + "km",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: ColorConstant.blackColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Stack(
            children: [
              distanceClientDestiny < 0.5 ?
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chegou ao Destino',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: ColorConstant.blackColor,
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width /3,
                      height: MediaQuery.of(context).size.height /18,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(ColorConstant.colorPrimary),
                          foregroundColor: MaterialStateProperty.all<Color>(ColorConstant.colorPrimary),
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return ColorConstant.colorPrimary.withOpacity(0.04);
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed))
                                return ColorConstant.whiteColor;
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),

                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                PaymentScreen(
                                  nome: widget.nome_cliente,
                                  sobrenome: '',
                                  telefone: widget.telefone_cliente,
                                  tipo: '',
                                  origem: widget.descrisao_partida_cliente,
                                  destino: widget.descrisao_chegada_cliente,
                                  valor: widget.preco_corrida_cliente,
                                  telefoneMotorista: widget.telefone_cliente,
                                  idCorrida: ''
                                ),

                            ),
                          );
                        },
                        child: Center(
                          child: Row(
                            children: [
                              const CircleAvatar(
                                child: Icon(
                                  size: 20,
                                  Icons.money_sharp,
                                  color: ColorConstant.colorPrimary,
                                ),
                                backgroundColor: ColorConstant.whiteColor,
                              ),

                              Text(
                                'Efectuar pagamento',
                                style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstant.whiteColor
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                :
              Center(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A Caminho do destino do cliente',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: ColorConstant.blackColor,
                      ),
                    ),

                    Platform.isIOS ? const CupertinoActivityIndicator() : LoaderMinConstant(),
                  ],
                ),
              ),
              distance < 0.4 ? Container(
                color: Colors.white,
              ) : Container(),

            ],
          ),



          //:::::::::::::::::::::: SPACE :::::::::::::::::::::::: :/
          const SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_sharp, color: Colors.green,),

                      Text(
                        widget.descrisao_partida_cliente,
                        style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),


                  Row(
                    children: [
                      const Icon(Icons.location_on_sharp, color: Colors.red,),

                      Text(
                        widget.descrisao_chegada_cliente,
                        style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),
                ],
              ),


              InkWell(
                onTap: () async {
                  await FlutterPhoneDirectCaller.callNumber('telefone_cli');

                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.black12,
                          shape: BoxShape.circle
                      ),
                      child: const Icon(Icons.call),
                    ),
                    Center(
                      child: Text(
                        'Ligar',
                        style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          )
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 1), () => setState((){

      distanceClientDestiny = calculateDistanceClienteDestino(
          widget.latitude_motorista,
          widget.longitude_motorista,
          widget.latitude_destino_cliente,
          widget.longitude_destino_cliente
      );
      //mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(locationProvider.latitude, locationProvider.longitude), zoom: 18)));
    }));
    return Column(
      children: [

        //-------------- MAP LOCATION -------------- -/
        Container(
          height: MediaQuery.of(context).size.height / 1.65,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                rotateGesturesEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                initialCameraPosition: CameraPosition(zoom: 14, target: LatLng(widget.latitude_motorista, widget.longitude_motorista)),
                markers: _markers,
                polylines:  Set<Polyline>.of(polylines.values),
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
              ),

              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                      color: ColorConstant.colorPrimary,
                      shape: BoxShape.circle
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.navigation_outlined,
                      color: ColorConstant.blackColor,
                    ),
                    onPressed: () async{
                      await launchUrl(
                        Uri.parse(
                          'google.navigation:q=${widget.latitude_destino_cliente}, ${widget.longitude_destino_cliente}&mode=d'
                        )
                      );
                    },
                  ),
                )
              )

            ],
          ),

        ),

        _clientDataRideAcept(),

      ],
    );
  }
}
