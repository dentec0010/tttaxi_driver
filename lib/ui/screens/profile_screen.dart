import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tttaxi_driver/constants/color_constant.dart';
import '../../constants/http_constant.dart';

class ScreenProfile extends StatefulWidget {
  ScreenProfile({Key? key,
    required this.id_motorista,
    required this.nome_motorista,
    required this.sobrenome_motorista,
    required this.telefone_motorista,
    required this.email_motorista,
    required this.bi_motorista,
    required this.passaport_motorista,
    required this.password_motorista,
  }) : super(key: key);

  String id_motorista;
  String nome_motorista;
  String sobrenome_motorista;
  String telefone_motorista;
  String email_motorista;
  String bi_motorista;
  String passaport_motorista;
  String password_motorista;


  @override
  _ScreenProfileState createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {

  TextEditingController? nome;
  TextEditingController? sobrenome;
  TextEditingController? telefone;
  TextEditingController? email;
  TextEditingController? bi;
  TextEditingController? passaport;
  TextEditingController? password;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  String edit_url = HttpConstant.url_api_edit_driver;

  @override
  void initState() {
    nome = TextEditingController();
    sobrenome = TextEditingController();
    telefone = TextEditingController();
    email = TextEditingController();
    bi = TextEditingController();
    passaport = TextEditingController();
    password = TextEditingController();
    super.initState();
  }


  void editData(){
    http.post(Uri.parse(edit_url),body: {
      'id_motorista': widget.id_motorista,
      'nome_motorista': nome!.text,
      'sobrenome_motorista':sobrenome!.text,
      'telefone_motorista':telefone!.text,
      'email_motorista':email!.text,
      'bi_motorista':bi!.text,
      'passaport_motorista':passaport!.text,
      'password_motorista':password!.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Container(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: _height / 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: const AssetImage('assets/images/logo.png'),
                    radius: _height / 10,
                  ),
                  SizedBox(
                    height: _height / 30,
                  ),
                  Text(
                    widget.nome_motorista + ' ' + widget.sobrenome_motorista,
                    style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: _height / 2.2),
            child: Container(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _height / 2.6,
                left: _width / 20,
                right: _width / 20),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: _height / 20),
                  child: Column(
                    children: <Widget>[
                      infoChild(_width, Icons.person, widget.nome_motorista + ' ' + widget.sobrenome_motorista),
                      infoChild(_width, Icons.phone, widget.telefone_motorista),
                      infoChild(_width, Icons.email, widget.email_motorista),
                      infoChild(_width, Icons.credit_card, widget.bi_motorista),
                      infoChild(_width, Icons.credit_card, widget.passaport_motorista),
                      Padding(
                        padding: EdgeInsets.only(top: _height / 30),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 12,
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                            color: ColorConstant.colorPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered))
                                    return ColorConstant.colorPrimary;
                                  if (states.contains(MaterialState.focused) ||
                                      states.contains(MaterialState.pressed))
                                    return ColorConstant.colorPrimary;
                                  return null; // Defer to the widget's default.
                                },
                              ),
                            ),
                            onPressed: (){
                              setState(() {
                                showDialog(context: context, builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0)), //this right here
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      height: MediaQuery.of(context).size.height / 2,
                                      width: MediaQuery.of(context).size.width,
                                      child: SingleChildScrollView(
                                        child: Form(
                                          key: _form,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              //----------------- SPACE ------------------- -/

                                              //----------- INPUT NAME ---------------- -/
                                              Container(
                                                padding: EdgeInsets.only(left: 30, top: 10),
                                                decoration: BoxDecoration(
                                                  //color: ConstantColor.colorPrimary,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(width: 1, color: Colors.black38)
                                                ),
                                                height: MediaQuery.of(context).size.height / 12,
                                                width: MediaQuery.of(context).size.width / 1.5,
                                                child: Center(
                                                  child: TextFormField(
                                                    maxLines: null,
                                                    textInputAction: TextInputAction.next,
                                                    decoration: InputDecoration.collapsed(
                                                      border: InputBorder.none,
                                                      hintText: widget.nome_motorista,
                                                      hintStyle: GoogleFonts.quicksand(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: ColorConstant.textColorBlack12
                                                      ),

                                                    ),
                                                    validator: (value) {
                                                      bool isEmpty = value!.trim().isEmpty;
                                                      bool isInvalid = value.trim().length < 3;

                                                      if (isEmpty || isInvalid) {
                                                        return 'Informe um Nome válido com 3 caracteres no minimo!';
                                                      }
                                                      return null;
                                                    },
                                                    keyboardType: TextInputType.text,
                                                    controller: nome,
                                                    // obscureText: true,
                                                  ),
                                                ),
                                              ),

                                              //----------------- SPACE ------------------- -/
                                              const SizedBox(height: 10,),

                                              //----------- INPUT SOBRENOME ---------------- -/
                                              Container(
                                                padding: EdgeInsets.only(left: 30),
                                                decoration: BoxDecoration(
                                                  //color: ConstantColor.colorPrimary,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(width: 1, color: Colors.black38)
                                                ),
                                                height: MediaQuery.of(context).size.height / 12,
                                                width: MediaQuery.of(context).size.width / 1.5,
                                                child: Center(
                                                  child: TextFormField(
                                                    maxLines: null,
                                                    textInputAction: TextInputAction.next,
                                                    decoration: InputDecoration.collapsed(
                                                      border: InputBorder.none,
                                                      hintText: widget.sobrenome_motorista,
                                                      hintStyle: GoogleFonts.quicksand(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: ColorConstant.textColorBlack12
                                                      ),

                                                    ),
                                                    validator: (value) {
                                                      bool isEmpty = value!.trim().isEmpty;
                                                      bool isInvalid = value.trim().length < 3;

                                                      if (isEmpty || isInvalid) {
                                                        return 'Informe um Sobrenome válido com 3 caracteres no minimo!';
                                                      }
                                                      return null;
                                                    },
                                                    keyboardType: TextInputType.text,
                                                    controller: sobrenome,
                                                    // obscureText: true,
                                                  ),
                                                ),
                                              ),

                                              //----------------- SPACE ------------------- -/

                                              const SizedBox(
                                                //width: 400,
                                                height: 10,
                                              ),

                                              //----------- INPUT NUMBER ---------------- -/
                                              Container(
                                                padding: EdgeInsets.only(left: 30),
                                                decoration: BoxDecoration(
                                                  //color: ConstantColor.colorPrimary,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(width: 1, color: Colors.black38)
                                                ),
                                                height: MediaQuery.of(context).size.height / 12,
                                                width: MediaQuery.of(context).size.width / 1.5,
                                                child: Center(
                                                  child: TextFormField(
                                                    maxLines: 1,
                                                    decoration: InputDecoration.collapsed(
                                                      border: InputBorder.none,
                                                      hintText: widget.telefone_motorista,
                                                      hintStyle: GoogleFonts.quicksand(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: ColorConstant.textColorBlack12
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      bool isEmpty = value!.trim().isEmpty;
                                                      bool isInvalid = value.trim().length < 9;

                                                      if (isEmpty || isInvalid) {
                                                        return 'Informe um terminal válido com 9 digitos!';
                                                      }
                                                      return null;
                                                    },
                                                    keyboardType: TextInputType.number,
                                                    controller: telefone,
                                                    // obscureText: true,
                                                  ),
                                                ),
                                              ),


                                              //----------------- SPACE ------------------- -/

                                              const SizedBox(
                                                //width: 400,
                                                height: 10,
                                              ),

                                              //----------- INPUT NUMBER ---------------- -/
                                              Container(
                                                padding: EdgeInsets.only(left: 30),
                                                decoration: BoxDecoration(
                                                  //color: ConstantColor.colorPrimary,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(width: 1, color: Colors.black38)
                                                ),
                                                height: MediaQuery.of(context).size.height / 12,
                                                width: MediaQuery.of(context).size.width / 1.5,
                                                child: Center(
                                                  child: TextFormField(
                                                    maxLines: 1,
                                                    decoration: InputDecoration.collapsed(
                                                      border: InputBorder.none,
                                                      hintText: widget.email_motorista,
                                                      hintStyle: GoogleFonts.quicksand(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: ColorConstant.textColorBlack12
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      bool isEmpty = value!.trim().isEmpty;
                                                      bool isInvalid = value.trim().length < 12;

                                                      if (isEmpty || isInvalid) {
                                                        return 'Informe um terminal válido com 12 digitos!';
                                                      }
                                                      return null;
                                                    },
                                                    keyboardType: TextInputType.emailAddress,
                                                    controller: email,
                                                    // obscureText: true,
                                                  ),
                                                ),
                                              ),


                                              //----------------- SPACE ------------------- -/

                                              const SizedBox(
                                                //width: 400,
                                                height: 10,
                                              ),

                                              //----------- INPUT NUMBER ---------------- -/
                                              Container(
                                                padding: EdgeInsets.only(left: 30),
                                                decoration: BoxDecoration(
                                                  //color: ConstantColor.colorPrimary,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(width: 1, color: Colors.black38)
                                                ),
                                                height: MediaQuery.of(context).size.height / 12,
                                                width: MediaQuery.of(context).size.width / 1.5,
                                                child: Center(
                                                  child: TextFormField(
                                                    maxLines: 1,
                                                    decoration: InputDecoration.collapsed(
                                                      border: InputBorder.none,
                                                      hintText: widget.bi_motorista,
                                                      hintStyle: GoogleFonts.quicksand(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: ColorConstant.textColorBlack12
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      bool isEmpty = value!.trim().isEmpty;
                                                      bool isInvalid = value.trim().length < 13;

                                                      if (isEmpty || isInvalid) {
                                                        return 'Informe um terminal válido com 13 digitos!';
                                                      }
                                                      return null;
                                                    },
                                                    keyboardType: TextInputType.text,
                                                    controller: bi,
                                                    // obscureText: true,
                                                  ),
                                                ),
                                              ),


                                              //----------------- SPACE ------------------- -/

                                              const SizedBox(
                                                //width: 400,
                                                height: 10,
                                              ),

                                              //----------- INPUT PASSAPORT ---------------- -/
                                              Container(
                                                padding: EdgeInsets.only(left: 30),
                                                decoration: BoxDecoration(
                                                  //color: ConstantColor.colorPrimary,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(width: 1, color: Colors.black38)
                                                ),
                                                height: MediaQuery.of(context).size.height / 12,
                                                width: MediaQuery.of(context).size.width / 1.5,
                                                child: Center(
                                                  child: TextFormField(
                                                    maxLines: 1,
                                                    decoration: InputDecoration.collapsed(
                                                      border: InputBorder.none,
                                                      hintText: widget.passaport_motorista,
                                                      hintStyle: GoogleFonts.quicksand(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: ColorConstant.textColorBlack12
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      bool isEmpty = value!.trim().isEmpty;
                                                      bool isInvalid = value.trim().length < 13;

                                                      if (isEmpty || isInvalid) {
                                                        return 'Informe um terminal válido com 13 digitos!';
                                                      }
                                                      return null;
                                                    },
                                                    keyboardType: TextInputType.text,
                                                    controller: passaport,
                                                    // obscureText: true,
                                                  ),
                                                ),
                                              ),


                                              //----------------- SPACE ------------------- -/

                                              const SizedBox(
                                                //width: 400,
                                                height: 10,
                                              ),

                                              //----------- INPUT PASSAPORT ---------------- -/
                                              Container(
                                                padding: EdgeInsets.only(left: 30),
                                                decoration: BoxDecoration(
                                                  //color: ConstantColor.colorPrimary,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(width: 1, color: Colors.black38)
                                                ),
                                                height: MediaQuery.of(context).size.height / 12,
                                                width: MediaQuery.of(context).size.width / 1.5,
                                                child: Center(
                                                  child: TextFormField(
                                                    maxLines: 1,
                                                    decoration: InputDecoration.collapsed(
                                                      border: InputBorder.none,
                                                      hintText: widget.password_motorista,
                                                      hintStyle: GoogleFonts.quicksand(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: ColorConstant.textColorBlack12
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      bool isEmpty = value!.trim().isEmpty;
                                                      bool isInvalid = value.trim().length < 13;

                                                      if (isEmpty || isInvalid) {
                                                        return 'Informe um terminal válido com 13 digitos!';
                                                      }
                                                      return null;
                                                    },
                                                    keyboardType: TextInputType.text,
                                                    controller: password,
                                                    // obscureText: true,
                                                  ),
                                                ),
                                              ),


                                              //----------------- SPACE ------------------- -/
                                              const SizedBox(height: 40,),

                                              //------------ BUTTON SEND ---------------- -/
                                              Container(
                                                height: MediaQuery.of(context).size.height / 12,
                                                width: MediaQuery.of(context).size.width / 1.2,
                                                decoration: BoxDecoration(
                                                  color: ColorConstant.colorPrimary,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                                          (Set<MaterialState> states) {
                                                        if (states.contains(MaterialState.hovered))
                                                          return ColorConstant.colorPrimary.withOpacity(0.04);
                                                        if (states.contains(MaterialState.focused) ||
                                                            states.contains(MaterialState.pressed))
                                                          return ColorConstant.textColor;
                                                        return null; // Defer to the widget's default.
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      editData();
                                                      Navigator.pop(context);
                                                    });

                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      'Editar',
                                                      style: GoogleFonts.quicksand(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: ColorConstant.whiteColor),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              });
                            },
                            child: Center(
                              child: Text(
                                'Editar',
                                style: GoogleFonts.quicksand(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstant.blackColor),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget infoChild(double width, IconData icon, data) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: InkWell(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: width / 10,
          ),
          Icon(
            icon,
            color: ColorConstant.colorPrimary,
            size: 26.0,
          ),
          SizedBox(
            width: width / 20,
          ),
          Text(data)
        ],
      ),
      onTap: () {
        print('Info Object selected');
      },
    ),
  );

  _edit(){
    return
      showDialog(context: context, builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            height: MediaQuery.of(context).size.height / 1.8,
            width: MediaQuery.of(context).size.width - 10,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  const SizedBox(height: 10,),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 14,
                      child: RaisedButton(
                        onPressed: () async {
                          //go to ride...
                          setState(() {
                            Navigator.pop(context);
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
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });

  }
}