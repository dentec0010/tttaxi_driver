import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tttaxi_driver/components/dashboard.dart';
import 'package:tttaxi_driver/constants/color_constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tttaxi_driver/ui/screens/payment_screen.dart';
import 'package:tttaxi_driver/ui/screens/ride_progress_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/http_constant.dart';
import '../../constants/loader_constant.dart';
import '../../constants/loader_min_constant.dart';
import '../../database/database_cliente.dart';
import '../../database/database_desejos.dart';
import '../../database/get_client.dart';
import '../../database/get_desejo.dart';
import '../../database/get_driver.dart';
import '../../models/model_coord.dart';
import '../../providers/location_provider.dart';

const double cameraZoom = 18;
const double cameraTilt = 18;
const double cameraBearing = 18;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.ride, required this.id_motorista, required this.telefone_motorista})
      : super(key: key);
  bool ride;
  String id_motorista;
  String telefone_motorista;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

const kGoogleApiKey = 'AIzaSyDnS-LAt0PZd0KgnpBrE24LMjhmMCk4tWE';
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final homeScaffoldKeyD = GlobalKey<ScaffoldState>();

class _HomeScreenState extends State<HomeScreen> {
  //-------------------- VALUES ----------------------------- -/
  GoogleMapController? mapController; //controller for Google map

  late Completer<GoogleMapController> controller1;
  PolylinePoints polylinePoints = PolylinePoints();
  PolylinePoints polylinePointsClientDestino = PolylinePoints();

  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  Map<PolylineId, Polyline> polylinesDestino = {}; //polylines to show direction
  Map<PolylineId, Polyline> polylinesvazio = {}; //polylines to show direction


  List<LatLng> polylineCoordinatess = [];
  List<LatLng> polylineCoordinatesClieneDestino = [];

  String descrisaoActual = '';
  String descrisaoAdm = '';
  LatLng _initialPosition = LatLng(0.0, 0.0);
  Set<Marker> _markers = Set();

  //------------------------------------------------------------------------
  double distance = 0.0;
  double distanceMotoristaCliente = 0.0;
  double distanceDestino = 0.0;

  String nome_cliente = '';
  String gostos = '';
  String valor = '';

  String lat_cliente = '';
  String long_cliente = '';
  String lat_destino_cliente = '';
  String long_destino_cliente = '';

  static const String inicial = '999999999';

  String id_cliente = '';
  String nome_usuario = '';
  String sobrenome_usuario = '';
  String telefone_usuario = '';
  String password_usuario = '';
  String id_estado = '';
  String id_corrida = '';
  String origem_corrida = '';
  String destino_corrida = '';

  String id_desejos = '';
  String desejo_corrida = '';




  String nome_cli = '';
  String sobrenome_cli = '';
  String telefone_cli = '';
  String password_cli = '';
  String id_estado_cli = '';

  String id_desejocorrida = '';
  String descricao_desejocorrida = '';

  bool chegou = false;
  bool chegou_destino = false;

  bool aceptRide = false;
  bool rotaClienteDestino = false;
  bool rotaMotoristaCliente = false;

  bool estado_motorista = false;
  static const ROOT = HttpConstant.url_get_running_all;

  late int indexx;
  static const ROOTT = HttpConstant.url_update_running;
  static const ROOTUP = HttpConstant.url_update_running_driver;

  double latitude_motorista = 0;
  double longitude_motorista = 0;

  @override
  void initState() {
    super.initState();
    _getUserLocation(latitude_motorista, longitude_motorista);
    //_getUserLocation();
    aceptRide = widget.ride;
    estado_motorista = false;
    chegou = false;
    chegou_destino = false;
    getRacing();
    aceptRide = false;
    rotaClienteDestino = false;
    rotaMotoristaCliente = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void editData(String id_corrida, String id_motorista, String descrisaoActual,
      String lat_motorista, String long_motorista) {
    http.post(Uri.parse(ROOTT), body: {
      'id_corrida': id_corrida,
      'id_motorista': id_motorista,
      'ponto_motorista': descrisaoActual,
      'latitude_motorista': lat_motorista,
      'longitude_motorista': long_motorista,
    });
  }


  void editDataCoord(String id_corrida,
      String lat_motorista, String long_motorista) {
    http.post(Uri.parse(ROOTUP), body: {
      'id_corrida': id_corrida,
      'latitude_motorista': lat_motorista,
      'longitude_motorista': long_motorista,
    });
  }



  Future<List> getRacing() async{
    final responce = await http.post(Uri.parse(ROOT));
    return jsonDecode(responce.body);
  }


  //-------------------- SEARCH VALUE ----------------------- -/

  //------------------- METHOD MAP -------------------- -/
  getDirections(double lat_cliente, double log_cliente, double lat_motorista, double log_motorista) async {

    BitmapDescriptor markerbitmaps = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/client_locations.png",
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
      totalDistance += calculateDistanceMotoristaCliente(
          polylineCoordinatess[i].latitude,
          polylineCoordinatess[i].longitude,
          polylineCoordinatess[i + 1].latitude,
          polylineCoordinatess[i + 1].longitude);
    }

    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId("1"),
        position: LatLng(lat_cliente, log_cliente),
        infoWindow: InfoWindow(title: 'Cliente'),
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

  //------------------- METHOD MAP -------------------- -/
  getDirectionsCientDestino(double lat_cliente, double log_cliente, double lat_motorista, double log_motorista) async {

    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/stopy.png",
    );

    PolylineResult result = await polylinePointsClientDestino.getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(lat_cliente, log_cliente),
      PointLatLng(lat_motorista, log_motorista),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinatesClieneDestino.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinatesClieneDestino.length - 1; i++) {
      totalDistance += calculateDistanceClienteDestino(
          polylineCoordinatesClieneDestino[i].latitude,
          polylineCoordinatesClieneDestino[i].longitude,
          polylineCoordinatesClieneDestino[i + 1].latitude,
          polylineCoordinatesClieneDestino[i + 1].longitude);
    }
    print(totalDistance);

    setState(() {

        /*polylines.clear();
        polylineCoordinatess.clear();
        polylinesDestino.clear();*/
      _markers.add(Marker(
        markerId: const MarkerId("2"),
        position: LatLng(lat_motorista, log_motorista),
        infoWindow: InfoWindow(title: 'Destino'),
        icon: markerbitmap,
      ));
     /*mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat_motorista, log_motorista), zoom: 18)
        //17 is new zoom level
      ));*/
      distanceDestino = totalDistance;
    });

    addPolyLineClientDestino(polylineCoordinatesClieneDestino);
  }

  double calculateDistanceMotoristaCliente(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double calculateDistanceClienteDestino(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.lightBlue,
      points: polylineCoordinates,
      width: 4,
    );

    polylines[id] = polyline;
    setState(() {});
  }

  addPolyLineClientDestino(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("polyli");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.orange,
      points: polylineCoordinates,
      width: 3,
    );
    polylinesDestino[id] = polyline;
    setState(() {});
  }

  //-------------------- MAP VALUES ------------------- -/
  _getUserLocation(double lat, double long) async {
    setState(() {
      _initialPosition = LatLng(lat, long);
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _initialPosition, zoom: 18)
          //17 is new zoom level
          ));
    });
    List<Placemark> placemark = await placemarkFromCoordinates(lat, long);
    descrisaoActual = '${placemark[0].name}';
    descrisaoAdm = '${placemark[0].administrativeArea}';
  }

  double _maxfont(double value, double max) {
    if (value < max) {
      return value;
    } else {
      return max;
    }
  }

  launchDialer(String number) async {
    String url = 'tel:' + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Application unable to open dialer.';
    }
  }

  //********************* WIDGET ROOT ********************** */
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size tamanhoFonte = mediaQuery.size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider()),
      ],
      child: Consumer(builder: (context, LocationProvider provider, _) {
        if (provider.status == LocationProviderStatus.Loading || provider.status == LocationProviderStatus.Initial) {
          return Center(child: LoaderConstant());
        } else if (provider.status == LocationProviderStatus.Success) {
          var locationProvider = Provider.of<UserLocation>(context);
          CameraPosition initialCameraPosition = CameraPosition(zoom: cameraZoom, target: LatLng(locationProvider.latitude, locationProvider.longitude));
          latitude_motorista = locationProvider.latitude;
          longitude_motorista = locationProvider.longitude;
          Timer(Duration(seconds: 1), () => setState((){
            //editDataCoord(id_corrida, locationProvider.latitude.toString(), locationProvider.longitude.toString());
            //distanceMotoristaCliente < 0.5 ? polylines.clear() : polylinesDestino.values;
            //getDirections(locationProvider.latitude, locationProvider.longitude, double.parse(lat_cliente), double.parse(long_cliente));
            distanceMotoristaCliente = calculateDistanceMotoristaCliente(locationProvider.latitude, locationProvider.longitude, double.parse(lat_cliente), double.parse(long_cliente));
            //distanceDestino = calculateDistanceClienteDestino(locationProvider.latitude, locationProvider.longitude, double.parse(lat_destino_cliente), double.parse(long_destino_cliente));
            mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(locationProvider.latitude, locationProvider.longitude), zoom: 18)));
          }));

          //_getUserLocation(locationProvider.latitude, locationProvider.longitude);
          return Column(
            children: [

              //-------------- MAP LOCATION -------------- -/
              Container(
                height: MediaQuery.of(context).size.height / 1.8,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      rotateGesturesEnabled: true,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      compassEnabled: true,
                      indoorViewEnabled: true,
                      scrollGesturesEnabled: true,
                      initialCameraPosition: initialCameraPosition,
                      markers: _markers,
                      polylines:  Set<Polyline>.of(polylines.values),
                      onMapCreated: (controller) {
                        setState(() {
                          mapController = controller;
                        });
                      },
                    ),
                  ],
                ),
              ),

              //----------------- LIST OF RIDE -------------------- -/
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3.2,
                decoration: BoxDecoration(
                  color: ColorConstant.transparent,
                ),
                child: aceptRide ? _clientDataRideAcept(nome_cliente, gostos, valor, locationProvider.latitude, locationProvider.longitude)
                  :
                Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Corridas Solicitadas',
                                  style: GoogleFonts.quicksand(
                                      color: ColorConstant.blackColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal),
                                ),

                                //-------------------- ICON STATE ---------------- -/
                                Platform.isIOS ?  CupertinoSwitch(
                                  value: estado_motorista,
                                  onChanged: (value) {
                                    setState(() {
                                      estado_motorista = value;
                                    });
                                  }
                                )
                                    : Switch(value: estado_motorista, onChanged: (value) {
                                    setState(() {
                                      estado_motorista = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: ColorConstant.transparent,
                              //border: Border.all(width: 1, color: Colors.black38)
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 4,
                                  child: Text(
                                    'Partida',
                                    style: GoogleFonts.quicksand(
                                        color: ColorConstant.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                //-------------------- ICON STATE ---------------- -/
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 4,
                                  child: Text(
                                    'Destino',
                                    style: GoogleFonts.quicksand(
                                        color: ColorConstant.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 4,
                                  child: Text(
                                    'Valor',
                                    style: GoogleFonts.quicksand(
                                        color: ColorConstant.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          estado_motorista ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: const BoxDecoration(
                              color: ColorConstant.transparent,
                              //border: Border.all(width: 1, color: Colors.black38),
                            ),
                            child: FutureBuilder<List>(
                              future: getRacing(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print("error");
                                }
                                if (snapshot.hasData) {
                                  //ListRacing(list: snapshot.data as List);
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.hasData == null ? 0 : snapshot.data!.length,
                                    padding: EdgeInsets.only(left: 10),
                                    itemBuilder: (context, index) {

                                      GetClientDatabase(id_cliente: snapshot.data![index]['id_cliente_corrida']).getClient().then((value) {
                                        nome_cli = value[0]['nome_usuario'];
                                        sobrenome_cli = value[0]['sobrenome_usuario'];
                                        telefone_cli = value[0]['telefone_usuario'];
                                        setState(() {});
                                      });

                                      GetDesejoDatabase(id_desejo: snapshot.data![index]['id_desejoscorrida']).getDesejo().then((value) {
                                        id_desejos = value[0]['id_desejocorrida'].toString();
                                        desejo_corrida = value[0]['descricao_desejocorrida'];
                                        setState(() {});
                                      });


                                      return InkWell(
                                        onTap: () {
                                          showDialog(context: context, builder: (BuildContextcontext) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0)),
                                              child: Container(
                                                height: MediaQuery.of(context).size.height / 1.8,
                                                width: MediaQuery.of(context).size.width - 10,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [

                                                      //--------------- TITLE ---------- -/
                                                      Text(
                                                        "Corrida Solicitada",
                                                        style: GoogleFonts.quicksand(
                                                            color: ColorConstant.blackColor,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold),
                                                      ),

                                                      const SizedBox(height: 10),

                                                      //--------------- NAME -------------- -/
                                                      Text(
                                                        nome_cli,
                                                        style: GoogleFonts.quicksand(
                                                          color: ColorConstant.blackColor,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold),
                                                      ),

                                                      const SizedBox(height: 5,),

                                                      //--------------- PHONE ---------------- -/
                                                      Text(
                                                        sobrenome_cli,
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
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              _adressTimeItem(Icons.location_on, snapshot.data![index]['ponto_partida'], Colors.green),
                                                              SizedBox(height: 10,),
                                                              _adressTimeItem(Icons.location_on, snapshot.data![index]['ponto_destino'], Colors.red),
                                                            ],
                                                          ),

                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.money,
                                                                  size: 20,
                                                                  color: ColorConstant.colorPrimary,
                                                                ),
                                                                SizedBox(
                                                                  width: 1,
                                                                ),

                                                                Text(
                                                                  snapshot.data![index]['valor_total_corrida'] + ' AOA',
                                                                  style: GoogleFonts.quicksand(
                                                                      color: ColorConstant.blackColor,
                                                                      fontSize: _maxfont(tamanhoFonte.width * 0.04, 12),
                                                                      fontWeight: FontWeight.bold),
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          /*_adressTimeItem(
                                                            Icons.money,
                                                            snapshot.data![index]['valor_total_corrida'] + ' AOA',
                                                            ColorConstant.colorPrimary
                                                          ),*/
                                                        ],
                                                      ),

                                                      const SizedBox(height: 20,),

                                                      //---------------- WISHES -------------- -/
                                                      Column(
                                                        children: [
                                                          _witches(desejo_corrida, ""),
                                                          const SizedBox(height: 20,),
                                                          _witches("Total", snapshot.data![index]['valor_total_corrida'].toString() + ' AOA'),
                                                        ],
                                                      ),

                                                      const SizedBox(height: 20,),

                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          height: MediaQuery.of(context).size.height / 14,
                                                          child: RaisedButton(
                                                            onPressed: () {
                                                              //go to ride...
                                                              setState(() async{
                                                                aceptRide = true;
                                                                rotaClienteDestino = true;
                                                                rotaMotoristaCliente = false;
                                                                //rotaClienteDestino && !rotaMotoristaCliente ?

                                                                getDirections(locationProvider.latitude, locationProvider.longitude, double.parse(snapshot.data![index]['latitude_origem']), double.parse(snapshot.data![index]['longitude_origem']));
                                                                nome_cliente = snapshot.data![index]['id_cliente_corrida'];
                                                                origem_corrida = snapshot.data![index]['ponto_partida'];
                                                                destino_corrida = snapshot.data![index]['ponto_destino'];
                                                                gostos = snapshot.data![index]['id_desejoscorrida'];
                                                                valor = snapshot.data![index]['valor_total_corrida'];
                                                                lat_cliente = snapshot.data![index]['latitude_origem'];
                                                                long_cliente = snapshot.data![index]['longitude_origem'];
                                                                lat_destino_cliente = snapshot.data![index]['latitude_destino'];
                                                                long_destino_cliente = snapshot.data![index]['longitude_destino'];
                                                                id_corrida = snapshot.data![index]['id_corrida'];
                                                                editData(snapshot.data![index]['id_corrida'], widget.id_motorista, descrisaoActual + ' ' + descrisaoAdm, locationProvider.latitude.toString(), locationProvider.longitude.toString());
                                                                 Navigator.pop(context);
                                                              });
                                                            },
                                                            child: Text(
                                                              "Aceitar Corrida",
                                                              style: GoogleFonts.quicksand(color: ColorConstant.whiteColor, fontSize: 18, fontWeight: FontWeight.bold),
                                                            ),
                                                            color: ColorConstant.colorPrimary,
                                                          ),
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
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                            color: ColorConstant.transparent,
                                            //border: Border.all(width: 1, color: Colors.black38),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width / 3.5,
                                                child: Text(
                                                  snapshot.data![index]['ponto_partida'],
                                                  style: GoogleFonts.quicksand(color: ColorConstant.blackColor,
                                                    fontSize: _maxfont(tamanhoFonte.width * 0.04, 16),
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              //-------------------- ICON STATE ---------------- -/
                                              Container(
                                                width: MediaQuery.of(context).size.width / 3.5,
                                                child: Text(
                                                  snapshot.data![index]['ponto_destino'],
                                                  style: GoogleFonts.quicksand(
                                                      color: ColorConstant.blackColor,
                                                      fontSize: _maxfont(tamanhoFonte.width * 0.04, 16),
                                                      fontWeight: FontWeight.normal),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              Container(
                                                width: MediaQuery.of(context).size.width / 3.5,
                                                child: Text(
                                                  snapshot.data![index]['valor_total_corrida'] + ' AOA',
                                                  style: GoogleFonts.quicksand(color: ColorConstant.blackColor,
                                                      fontSize: _maxfont(tamanhoFonte.width * 0.04, 16),
                                                      fontWeight: FontWeight.normal),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return Container(
                                    height: 40,
                                    width: 40,
                                    child: Center(
                                      child: Platform.isIOS ? CupertinoActivityIndicator() : LoaderConstant(),
                                    )
                                );
                              },
                            ),

                          )
                        :
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 8,
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Para ver corridas solicidatas\n deves estar online',
                                  style: GoogleFonts.quicksand(
                                      color: ColorConstant.blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ],
          );
        } else {
          return Center(child: Text("Não encontramos a sua localização."));
        }
      }),
    );
  }

  //********************* CLIENT DATA RIDE ACEPT ************************ */
  _clientDataRideAcept(String nome_cliente, String desejo, String valor, double latitude, double longitude) {
    rotaClienteDestino = false;
    rotaMotoristaCliente = true;

    //getDirectionsCientDestino(double.parse(lat_cliente), double.parse(long_cliente),double.parse(lat_destino_cliente), double.parse(long_destino_cliente));
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 6,
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
                              image: AssetImage("assets/images/patrao.jpg"),
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
                            nome_cli,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: ColorConstant.blackColor,
                            ),
                          ),

                          //------------------- SPACE -------------------- -/

                          Text(
                            telefone_cli,
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
                        valor + ' AOA',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: ColorConstant.blackColor,
                        ),
                      ),
                      Text(
                        distanceMotoristaCliente.toStringAsFixed(2) + "km",
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
              distanceMotoristaCliente < 0.4 ?
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chegou ao cliente',
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
                                MenuDashboardPage(
                                  telefone: telefone_cli,
                                  ride: false,
                                  driver_arrive: true,
                                  latitude_motorista: latitude,
                                  longitude_motorista: longitude,
                                  latitude_destino: double.parse(lat_destino_cliente),
                                  longitude_destino: double.parse(long_destino_cliente),
                                  nome_cliente: nome_cli,
                                  telefone_cliente: telefone_cli,
                                  kilometro_corrida_cliente: distanceMotoristaCliente.toStringAsFixed(2) ,
                                  preco_corrida_cliente: valor,
                                  descrisao_partida_cliente: origem_corrida,
                                  descrisao_chegada_cliente: destino_corrida,
                                ),
                                /*RideProgressScreen(
                                  latitude_motorista: latitude_motorista,
                                  longitude_motorista: longitude_motorista,
                                  latitude_destino_cliente: double.parse(lat_destino_cliente),
                                  longitude_destino_cliente: double.parse(long_destino_cliente)

                                ),*/
                            ),
                          );
                        },
                            //getDirectionsClientDestino(double.parse(lat_cliente), double.parse(long_cliente),double.parse(lat_destino_cliente), double.parse(long_destino_cliente)),
                        child: Center(
                          child: Row(
                            children: [
                              const CircleAvatar(
                                child: Icon(
                                  size: 20,
                                  Icons.run_circle,
                                  color: ColorConstant.colorPrimary,
                                ),
                                backgroundColor: ColorConstant.whiteColor,
                              ),

                              Text(
                                'Iniciar Corrida',
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
              ) :
              Center(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A Caminho',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: ColorConstant.blackColor,
                      ),
                    ),

                    Platform.isIOS ? CupertinoActivityIndicator() : LoaderMinConstant(),
                  ],
                ),
              ),
              distanceDestino < 0.4 ? Container(
                color: Colors.white,
              ): Container(),

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
                      Icon(Icons.location_on_sharp, color: Colors.green,),

                      Text(
                        origem_corrida,
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
                      Icon(Icons.location_on_sharp, color: Colors.red,),

                      Text(
                        destino_corrida,
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
                  await FlutterPhoneDirectCaller.callNumber(telefone_cli);
                  //FlutterPhoneDirectCaller.callNumber(telefone_cli);
                  //FlutterPhoneDirectCaller.callNumber(telefone_cli);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          shape: BoxShape.circle
                      ),
                      child: Icon(Icons.call),
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

  //*********************** ITEM RIDE *************************** */
  _itemRide(IconData iconData, String description1, String description2) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          iconData,
          size: 40,
          color: ColorConstant.blackColor,
        ),
        Text(
          description1,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: ColorConstant.blackColor,
          ),
        ),
        Text(
          description2,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: ColorConstant.blackColor,
          ),
        ),
      ],
    );
  }

  //**************** ADRESS & TIME ************* */
  _adressTimeItem(IconData iconData, String description, Color color) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size tamanhoFonte = mediaQuery.size;
    return Container(
      child: Row(
        children: [
          Icon(
            iconData,
            size: 20,
            color: color,
          ),
          SizedBox(
            width: 1,
          ),
          Container(
            width: 120,
            child: Text(
              description,
              style: GoogleFonts.quicksand(
                  color: ColorConstant.blackColor,
                  fontSize: _maxfont(tamanhoFonte.width * 0.04, 12),
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  //****************** WITCHES ******************* */
  _witches(String description, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          description,
          style: GoogleFonts.quicksand(
              color: ColorConstant.blackColor,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        Text(
          price,
          style: GoogleFonts.quicksand(
              color: ColorConstant.blackColor,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

