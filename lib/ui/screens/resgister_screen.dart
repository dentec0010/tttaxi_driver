import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tttaxi_driver/ui/widgets/register_one_widget.dart';
import '../../constants/color_constant.dart';
import '../../constants/http_constant.dart';
import '../../database/database_motorista.dart';
import '../../services/notification.dart';
import '../widgets/register_three_widget.dart';
import '../widgets/register_two_widget.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'welcome_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {




  bool isComplete = false;
  int currentStep = 0;

  final url_api_add_driver = HttpConstant.url_api_add_driver;
  final url_api_get_driver = HttpConstant.url_api_get_driver;
  String dialCodeDigits = "+244";
  File ? image;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  TextEditingController? _nome_motorista_controller;
  TextEditingController? _sobrenome_motorista_controller;
  TextEditingController? _telefone_motorista_controller;
  TextEditingController? _email_motorista_controller;
  TextEditingController? _bi_motorista_controller;
  TextEditingController? _passaport_motorista_controller;
  TextEditingController? _password_motorista_controller;

  int _codigo = 9999;
  bool _notificacao = false;
  bool valor = false;

  void _gerarNumero() {
    setState(() {
      Random numeroAleatorio = new Random();
      _codigo = numeroAleatorio.nextInt(9999);
    });
  }



  showNotification(int code) {
    setState(() {
      valor = !valor;
      if (valor) {
        Provider.of<NotificationService>(context, listen: false).showLocalNotification(
          CustomNotification(
            id: 1,
            title: 'TT-Táxi',
            body: 'Código de Confirmação $code',
            payload: '/notificacao',
          ),
        );
      }
    });
  }

  final nome_motorista = FocusNode();
  final sobrenome_motorista = FocusNode();
  final telefone_motorista = FocusNode();
  final email_motorista = FocusNode();
  final bi_motorista = FocusNode();
  final passaport_motorista = FocusNode();
  final password_motorista = FocusNode();


  //********************** INITSTATE ********************** */
  @override
  void initState() {
    super.initState();
    _nome_motorista_controller = TextEditingController();
    _sobrenome_motorista_controller = TextEditingController();
    _telefone_motorista_controller = TextEditingController();
    _email_motorista_controller = TextEditingController();
    _bi_motorista_controller = TextEditingController();
    _passaport_motorista_controller = TextEditingController();
    _password_motorista_controller = TextEditingController();


  }

  @override
  void dispose() {
    super.dispose();
    nome_motorista.dispose();
    sobrenome_motorista.dispose();
    telefone_motorista.dispose();
    email_motorista.dispose();
    bi_motorista.dispose();
    passaport_motorista.dispose();
    password_motorista.dispose();
  }


  //********************** GET IMAGE GALERY ********************** */
  Future pickedImage(ImageSource imageSourceGalery) async{
    try{
      final image = await ImagePicker().pickImage(source: imageSourceGalery);
      if(image == null) return;
      final TemporaryImage = File(image.path);
      setState(() {
        this.image = TemporaryImage;
      });
    } on PlatformException catch(e){
      //AlertDialog...
    }
  }

  //********************** GET IMAGE CAMERA ********************** */
  Future pickedImageCamera(ImageSource imageSource) async{
    try{
      final image = await ImagePicker().pickImage(source: imageSource);
      if(image == null) return;
      final TemporaryImage = File(image.path);
      setState(() {
        this.image = TemporaryImage;
      });
    } on PlatformException catch(e){
      //AlertDialog...
    }
  }

  //********************** UPLOAD PHOTO MOTORISTA ********************** */
  Future uploadImage() async {
    final uri = Uri.parse(HttpConstant.url_upload_foto_motorista);
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = _telefone_motorista_controller!.text;
    var pic = await http.MultipartFile.fromPath("image", image!.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploded');
    } else {
      print('Image Not Uploded');
    }
    setState(() {});
  }


  void _addMotorista(){
    var url = url_api_add_driver;
    http.post(Uri.parse(url),body: {
      "nome_motorista": _nome_motorista_controller!.text,
      "sobrenome_motorista": _sobrenome_motorista_controller!.text,
      "telefone_motorista": _telefone_motorista_controller!.text,
      "email_motorista": _email_motorista_controller!.text,
      "bi_motorista": _bi_motorista_controller!.text,
      "passaport_motorista": _passaport_motorista_controller!.text,
      "password_motorista": _password_motorista_controller!.text,
      "id_estado": '2',
    });
  }

  /*addMotorista() {
    MotoristaDatabase.addDriver(_nome_motorista_controller!.text, _sobrenome_motorista_controller!.text, _telefone_motorista_controller!.text,
        _email_motorista_controller!.text, _bi_motorista_controller!.text,
        _passaport_motorista_controller!.text, _password_motorista_controller!.text, '2')
        .then((result) {
      if ('success' == result) {
        //_clearValues();
      }
    });
  }*/

  Future confirmMotorista() async {
    final responce = await http.post(Uri.parse(url_api_get_driver), body: {
      "telefone_motorista": _telefone_motorista_controller!.text,
    });
    var data =  jsonDecode(responce.body);
    if (data == "Success") {
      _errorAlert(context);
    } else {
      uploadImage();
      _addMotorista();
      return _sucessAlert(context);
    }
  }

  //**************** WIDGET ROOT ******************** */
  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: ColorConstant.whiteColor,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _form,
            child: Column(
              children: [

                //------------------- INPUT PHOTO -------------------- -/
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4,
                  child: Center(
                    child: Stack(
                      children: [

                        Positioned(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 5,
                            width: MediaQuery.of(context).size.width / 2.5,
                            decoration: BoxDecoration(
                              color: ColorConstant.whiteColor,
                              borderRadius: BorderRadius.circular(300),
                              border: Border.all(width: 1, color: Colors.black38),
                            ),
                            child: image != null ?
                            CircleAvatar(
                              backgroundImage: FileImage(
                                image!,
                              ), radius: 300.0,
                            ) : Container(),
                          ),
                        ),

                        Positioned(
                          top: MediaQuery.of(context).size.height / 8,
                          left: MediaQuery.of(context).size.width / 3.5,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: ColorConstant.whiteColor,
                              borderRadius: BorderRadius.circular(60.0),
                              border: Border.all(width: 1, color: Colors.black38),
                            ),
                            child: InkWell(
                              onTap: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    AlertDialog(
                                      title: Center(
                                        child: Text(
                                          'Escolha a opção',
                                          style: GoogleFonts.quicksand(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: ColorConstant.blackColor),
                                        ),
                                      ),
                                      content: Container(
                                        height: MediaQuery.of(context).size.height / 12,
                                        width: MediaQuery.of(context).size.width / 4,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [

                                            //-------------- CAMERA ---------------- -/
                                            InkWell(
                                              onTap: (){
                                                pickedImageCamera(ImageSource.camera);
                                                Navigator.pop(context, 'camera');
                                              },
                                              child: Column(
                                                children: [

                                                  Icon(
                                                    Icons.camera,
                                                    size: 30,
                                                  ),

                                                  Text(
                                                    'Camera',
                                                    style: GoogleFonts.quicksand(
                                                        color: ColorConstant.blackColor,
                                                        fontSize: 16
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),

                                            //-------------- GALERY ---------------- -/
                                            InkWell(
                                              onTap: (){
                                                pickedImage(ImageSource.gallery);
                                                Navigator.pop(context, 'galery');
                                              },
                                              child: Column(
                                                children: [

                                                  Icon(
                                                    Icons.photo,
                                                    size: 30,
                                                  ),

                                                  Text(
                                                    'Galeria',
                                                    style: GoogleFonts.quicksand(
                                                        color: ColorConstant.blackColor,
                                                        fontSize: 16
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              ),
                              child: Icon(
                                Icons.add_a_photo_rounded,
                                size: 20,
                                color: ColorConstant.textColorBlack12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //----------- INPUT NAME ---------------- -/
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
                    child: TextFormField(
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        /* border: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(15),
                       // borderSide: new BorderSide(width: 1, color: Colors.black38),
                      ),*/
                        hintText: 'Nome',
                        hintStyle: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.textColorBlack12
                        ),

                      ),
                      focusNode: nome_motorista,
                      controller: _nome_motorista_controller,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(sobrenome_motorista);
                      },
                      validator: (value) {
                        bool isEmpty = value!.trim().isEmpty;
                        bool isInvalid = value.trim().length < 5;

                        if (isEmpty || isInvalid) {
                          return 'Informe um Nome válido com 5 caracteres no minimo!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      // obscureText: true,
                    ),
                  ),
                ),

                //----------------- SPACE ------------------- -/
                const SizedBox(height: 10,),

                //----------- INPUT SORENOME ---------------- -/
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
                    child: TextFormField(
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        /* border: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(15),
                       // borderSide: new BorderSide(width: 1, color: Colors.black38),
                      ),*/
                        hintText: 'Sobrenome',
                        hintStyle: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.textColorBlack12
                        ),

                      ),
                      focusNode: sobrenome_motorista,
                      controller: _sobrenome_motorista_controller,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(telefone_motorista);
                      },
                      validator: (value) {
                        bool isEmpty = value!.trim().isEmpty;
                        bool isInvalid = value.trim().length < 5;

                        if (isEmpty || isInvalid) {
                          return 'Informe um Nome válido com 5 caracteres no minimo!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      // obscureText: true,
                    ),
                  ),
                ),

                //----------------- SPACE ------------------- -/
                const SizedBox(height: 10,),

                //----------- INPUT NUMBER ---------------- -/
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
                    child: TextFormField(
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
                      controller: _telefone_motorista_controller,
                      focusNode: telefone_motorista,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(email_motorista);
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

                //----------- INPUT EMAIL ---------------- -/
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
                    child: TextFormField(
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        /* border: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(15),
                       // borderSide: new BorderSide(width: 1, color: Colors.black38),
                      ),*/
                        hintText: 'E-mail',
                        hintStyle: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.textColorBlack12
                        ),
                      ),
                      controller: _email_motorista_controller,
                      focusNode: email_motorista,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(bi_motorista);
                      },
                      validator: (value) {
                        bool isEmpty = value!.trim().isEmpty;
                        bool isInvalid = value.trim().length < 8;

                        if (isEmpty || isInvalid) {
                          return 'Informe um Nome válido com 8 caracteres no minimo!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      // obscureText: true,
                    ),
                  ),
                ),

                //----------------- SPACE ------------------- -/
                const SizedBox(height: 10,),

                //----------- INPUT BI ---------------- -/
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
                    child: TextFormField(
                      maxLines: null,
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        /* border: UnderlineInputBorder(
                      borderRadius: new BorderRadius.circular(15),
                     // borderSide: new BorderSide(width: 1, color: Colors.black38),
                    ),*/
                        hintText: 'Bilhete de Identidade',
                        hintStyle: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.textColorBlack12
                        ),
                      ),
                      controller: _bi_motorista_controller,
                      focusNode: bi_motorista,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(passaport_motorista);
                      },
                      validator: (value) {
                        bool isEmpty = value!.trim().isEmpty;
                        bool isInvalid = value.trim().length < 13;

                        if (isEmpty || isInvalid) {
                          return 'Informe um BI válido com 13 caracteres no minimo!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      // obscureText: true,
                    ),
                  ),
                ),

                //----------------- SPACE ------------------- -/
                const SizedBox(height: 10,),

                //----------- INPUT PASSAPORT ---------------- -/
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
                    child: TextFormField(
                      maxLines: null,
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        /* border: UnderlineInputBorder(
                      borderRadius: new BorderRadius.circular(15),
                     // borderSide: new BorderSide(width: 1, color: Colors.black38),
                    ),*/
                        hintText: 'Passaport',
                        hintStyle: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.textColorBlack12
                        ),
                      ),
                      controller: _passaport_motorista_controller,
                      focusNode: passaport_motorista,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(password_motorista);
                      },
                      validator: (value) {
                        bool isEmpty = value!.trim().isEmpty;
                        bool isInvalid = value.trim().length < 13;

                        if (isEmpty || isInvalid) {
                          return 'Informe um Passaport válido com 13 caracteres no minimo!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
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
                    child: TextFormField(
                      maxLines: null,
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
                      controller: _password_motorista_controller,
                      focusNode: password_motorista,
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
                      // obscureText: true,
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
                      'Já tem uma conta?',
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
                            builder: (BuildContext context) => LoginScreen(),
                            //ProductPage
                          ),
                        );
                      },
                      child: Text(
                        'Entrar',
                        style: GoogleFonts.quicksand(
                          color: ColorConstant.colorPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Container(
                      margin: EdgeInsets.only(
                        bottom: isKeyboard ? MediaQuery.of(context).size.height / 4 :
                        MediaQuery.of(context).size.height / 12 ,
                      ),
                      child: TextButton(
                        onPressed: (){
                          setState((){
                            if(_form.currentState == null){
                              null;
                            } else if(_form.currentState!.validate()){
                              _gerarNumero();
                              confirmMotorista();
                              showNotification(_codigo);
                            }
                          });
                          //confirmMotorista();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstant.colorPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: MediaQuery.of(context).size.height / 12,
                          width: MediaQuery.of(context).size.width / 3,
                          child: Center(
                            child: Text(
                               'Próximo',
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

                    Container(
                      margin: EdgeInsets.only(
                          bottom: isKeyboard ? MediaQuery.of(context).size.height / 4 :
                          MediaQuery.of(context).size.height / 12
                      ),
                      child: TextButton(
                        onPressed: (){

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstant.colorClickButton,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: MediaQuery.of(context).size.height / 12,
                          width: MediaQuery.of(context).size.width / 3,
                          child: Center(
                            child: Text(
                              'Anterior',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: ColorConstant.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }


  //******************** GET STEPS ********************* */
  /*List<Step> getSteps() => [
    Step(
      isActive: currentStep >= 0,
      title: Text(''),
      content:
      state: currentStep >= 0 ? StepState.complete : StepState.disabled,
    ),
    Step(
      isActive: currentStep >= 1,
      title: Text(''),
      content: RegisterTwoWidget(),
      state: currentStep >= 1 ? StepState.complete : StepState.disabled,
    ),
    Step(
      isActive: currentStep >= 2,
      title: Text(''),
      content: RegisterThreeWidget(),
      state: currentStep >= 2 ? StepState.complete : StepState.disabled,
    ),
  ];*/


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
      desc: "Motorista já registado.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.red,
        )
      ],
    ).show();
  }

  _sucessAlert(BuildContext context) {
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
      desc: "Motorista registado com sucesso.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            setState((){

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ScreenCheckCode(
                    codigoDeConfirmacao: _codigo,
                    notificacao: true,
                    telefoneCliente: _telefone_motorista_controller!.text,
                  ),
                ),
                    (route) => false,
              );
            });
          },
          color: Colors.blue,
        )
      ],
    ).show();
  }






}
