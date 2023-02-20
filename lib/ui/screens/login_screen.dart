import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_network_connectivity/flutter_network_connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tttaxi_driver/ui/screens/welcome_screen.dart';
import '../../components/dashboard.dart';
import '../../constants/color_constant.dart';
import '../../constants/http_constant.dart';
import '../../constants/loader_constant.dart';
import 'resgister_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key,}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FlutterNetworkConnectivity _flutterNetworkConnectivity =
  FlutterNetworkConnectivity(
    isContinousLookUp: true,
    // optional, false if you cont want continous lookup.
    lookUpDuration: const Duration(seconds: 5),
    // optional, to override default lookup duration.
    // lookUpUrl: 'example.com', // optional, to override default lookup url
  );

  bool? _isInternetAvailableOnCall;
  bool _isInternetAvailableStreamStatus = false;

  StreamSubscription<bool>? _networkConnectionStream;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final telefone_motorista = FocusNode();
  final senha_motorista = FocusNode();

  TextEditingController _telefone_usuario_controller = TextEditingController();
  TextEditingController _senha_usuario_controller = TextEditingController();

  final url_api = HttpConstant.url_api_login;

  String? telefone_usuario, senha_usuario;
  int userCount = 0;
  bool loading = false;


  //********************** INITSTATE ********************** */
  @override
  void initState() {
    super.initState();
    loading = false;
    _flutterNetworkConnectivity.getInternetAvailabilityStream().listen((event) {
      _isInternetAvailableStreamStatus = event;
      setState(() {});
    });
    init();
  }

  @override
  void dispose() {
    _networkConnectionStream?.cancel();
    _flutterNetworkConnectivity.unregisterAvailabilityListener();
    super.dispose();
    telefone_motorista.dispose();
    senha_motorista.dispose();
  }

  void init() async {
    await _flutterNetworkConnectivity.registerAvailabilityListener();
  }

  Future login() async {
    String tel = _telefone_usuario_controller.text;
    var response = await http.post(Uri.parse(url_api), body: {
      "telefone_motorista": _telefone_usuario_controller.text,
      "password_motorista": _senha_usuario_controller.text,
    });
    loading = true;
    var data = json.decode(response.body);
    if (data == "Success") {
      _sucessAlert(context, tel);
      loading = false;
    } else {
      loading = true;
      return _errorAlert(context);
    }
  }


  //********************** WIDGET ROOT ********************** */
  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: Center(
        //width: MediaQuery.of(context).size.width / 1.12,
        //height: !isKeyboard ? MediaQuery.of(context).size.height
        // : MediaQuery.of(context).size.height / 1.5,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [

                //--------------- IMAGE LOGO ---------------- -/
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    image: const DecorationImage(
                        image: AssetImage("assets/images/entrar.jpg"),
                        fit: BoxFit.fill
                    ),
                  ),
                ),

                //------------------------- SPACE ------------------------- -/
                const SizedBox(height: 20,),

                //----------- INPUT NUMBER ---------------- -/
                Container(
                  padding: const EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                    //color: ConstantColor.colorPrimary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.black38)
                  ),
                  height: MediaQuery.of(context).size.height / 12,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Center(
                    child: Platform.isIOS ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        placeholder: '9XX XXX XXX',
                      ),
                    )
                        : TextFormField(
                      maxLines: null,
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        /* border: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(15),
                       // borderSide: new BorderSide(width: 1, color: Colors.black38),
                      ),*/
                        hintText: '+244 9XX XXX XXX',
                        hintStyle: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.textColorBlack12
                        ),
                      ),
                      focusNode: telefone_motorista,
                      controller: _telefone_usuario_controller,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(senha_motorista);
                      },
                      validator: (value) {
                        bool isEmpty = value!.trim().isEmpty;
                        bool isInvalid = value.trim().length < 9;

                        if (isEmpty || isInvalid) {
                          return 'Informe um terminal válido com 9 digitos!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      // obscureText: true,
                    ),
                  ),
                ),


                //----------------- SPACE ------------------- -/
                const SizedBox(height: 10,),

                //----------- INPUT PASSWORD ---------------- -/
                Container(
                  padding: EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                    //color: ConstantColor.colorPrimary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.black38)
                  ),
                  height: MediaQuery.of(context).size.height / 12,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Center(
                    child: Platform.isIOS ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        placeholder: 'Senha',
                      ),
                    )
                        : TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        /* border: UnderlineInputBorder(
                          borderRadius: new BorderRadius.circular(15),
                         // borderSide: new BorderSide(width: 1, color: Colors.black38),
                        ),*/
                        hintText: 'Senha',
                        hintStyle: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.textColorBlack12
                        ),
                      ),
                      focusNode: senha_motorista,

                      controller: _senha_usuario_controller,
                      validator: (value) {
                        bool isEmpty = value!.trim().isEmpty;
                        bool isInvalid = value.trim().length < 5;

                        if (isEmpty || isInvalid) {
                          return 'Informe um Nome válido com 5 caracteres no minimo!';
                        }
                        return null;
                      },
                      //onChanged: (value) => setState(() => senha_motorista = value),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                  ),
                ),

                //------------------- SPACE ---------------- -/
                const SizedBox(height: 20,),

                //--------------- QUETION USER ------------ -/
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    //::::::::::::::: QUETION ::::::::::::: :/
                    Text(
                      'Não tem uma conta?',
                      style: GoogleFonts.quicksand(
                          color: ColorConstant.blackColor,
                          fontSize: 14
                      ),
                    ),

                    //::::::::::::::: SPACE :::::::::::::::: :/
                    const SizedBox(width: 10,),

                    //:::::::::::::::: ANSWER :::::::::::::: :/
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => RegisterScreen(),
                            //ProductPage
                          ),
                        );
                      },
                      child: Text(
                        'Registar',
                        style: GoogleFonts.quicksand(
                          color: ColorConstant.colorPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                //------------------- SPACE ---------------- -/
                const SizedBox(height: 20,),

                loading ? LoaderConstant() : InkWell(
                  onTap: (){
                    setState((){
                      loading = true;
                    });
                    login();
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorConstant.colorPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: MediaQuery.of(context).size.height / 12,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Center(
                        child: Text(
                          'Entrar',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: ColorConstant.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                _isInternetAvailableStreamStatus
                ? Text(
                    '',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: ColorConstant.blackColor,
                    ),
                  )
                : Column(
                    children: [
                      Icon(
                        Icons.warning,
                        size: 50,
                        color: ColorConstant.colorPrimary,
                      ),
                      Text(
                        'Estas Offline, Conecte-se a internet.',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
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
      ),
    );
  }

  _errorAlert(BuildContext context) {
    var alertStyle = AlertStyle(
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.error,
      title: "Erro!",
      desc: "Usuário ou Senha errados.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            loading = false;
          },
          color: Colors.red,
        )
      ],
    ).show();
  }

  _sucessAlert(BuildContext context, String tel) {
    var alertStyle = AlertStyle(
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.blue,
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.success,
      title: "Sucesso",
      desc: "Login efectuado com sucesso.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            loading = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MenuDashboardPage(
                  telefone: _telefone_usuario_controller.text,
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
          },
          color: Colors.blue,
        )
      ],
    ).show();
  }

  _checkConnection(BuildContext context) {
    var alertStyle = AlertStyle(
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.warning,
      title: "Aviso",
      desc: "Estás Offline, Conecte-se a internet",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });

          },
          color: Colors.red,
        )
      ],
    ).show();
  }


}
