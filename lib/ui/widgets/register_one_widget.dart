import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';
import '../../constants/color_constant.dart';
import '../screens/login_screen.dart';

class RegisterOneWidget extends StatefulWidget {
  RegisterOneWidget({Key? key,}) : super(key: key);
 // final bool form;



  @override
  State<RegisterOneWidget> createState() => _RegisterOneWidgetState();
}

class _RegisterOneWidgetState extends State<RegisterOneWidget> {

  File ? image;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final nome_completo_motorista = FocusNode();
  final carta_de_conducao_motorista = FocusNode();
  final categoria_motorista = FocusNode();
  final telefone_motorista = FocusNode();
  final telefone_motorista1 = FocusNode();
  final email_motorista = FocusNode();
  final bi_motorista = FocusNode();
  final passaporte_motorista = FocusNode();
  final data_de_nascimento = FocusNode();
  final data_de_registro = FocusNode();
  final nacionalidade_motorista = FocusNode();
  final senha_motorista = FocusNode();
  bool estado_motorista = false;



  bool endereco = false;





  //********************** INITSTATE ********************** */
  @override
  void initState() {
    super.initState();
    endereco = false;
  }

  @override
  void dispose() {
    super.dispose();
    nome_completo_motorista.dispose();
    telefone_motorista.dispose();
    telefone_motorista1.dispose();
    email_motorista.dispose();
    bi_motorista.dispose();
    passaporte_motorista.dispose();
    data_de_nascimento.dispose();
    data_de_registro.dispose();
    nacionalidade_motorista.dispose();
    senha_motorista.dispose();
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

  //********************** WIDGET ROOT ********************** */
  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Center(
       //width: MediaQuery.of(context).size.width / 1.12,
      //height: !isKeyboard ? MediaQuery.of(context).size.height
      // : MediaQuery.of(context).size.height / 1.5,
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
                  focusNode: nome_completo_motorista,
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
                  focusNode: bi_motorista,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(passaporte_motorista);
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
                  focusNode: passaporte_motorista,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(senha_motorista);
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
                  focusNode: senha_motorista,
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


          ],
        ),
      ),
    );
  }
}
