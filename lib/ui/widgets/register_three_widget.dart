
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:tttaxi_driver/constants/color_constant.dart';

import '../screens/welcome_screen.dart';

class ScreenCheckCode extends StatefulWidget {
  ScreenCheckCode({
    Key? key,
    required this.codigoDeConfirmacao,
    required this.notificacao,
    required this.telefoneCliente,
  }) : super(key: key);
  int codigoDeConfirmacao;
  bool notificacao;
  String telefoneCliente;

  @override
  State<ScreenCheckCode> createState() => _ScreenCheckCodeState();
}

class _ScreenCheckCodeState extends State<ScreenCheckCode> {

  final GlobalKey<ScaffoldState> _scaffollkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinTextEditingController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  String? verificationCode;

  //****************************************************
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    verifyPhoneNumber();
    super.initState();
  }



  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
      color: ColorConstant.colorPrimary,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.grey,
      ));

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+244"+widget.telefoneCliente,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          if (value.user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => WelcomeScreen(telefone: widget.telefoneCliente,),
              ),
            );
          }
        });
      },
      verificationFailed: (FirebaseAuthException e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 3),
          ),
        );
      },
      codeSent: (String vID, int? resentToken){
        setState(() {
          verificationCode = vID;
        });
      },
      codeAutoRetrievalTimeout: (String vID){
        setState(() {
          verificationCode = vID;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }


  //**************** WIDGET ROOT ************* */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [

          //--------------- APPBAR --------------- -/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [



              //----------------- SPACE ------------------- -/
              const SizedBox(width: 80,),

              Container(
                margin: EdgeInsets.only(top: 40),
                child: Text(
                  'Cadastrar',
                  style: GoogleFonts.quicksand(
                      color: ColorConstant.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
              ),
            ],
          ),

          //----------------- SPACE ------------------- -/
          const SizedBox(height: 110,),

          //--------------- WELCOME TEXT ---------- -/
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Bem-Vindo ao T-T TÁXI',
              style: GoogleFonts.quicksand(
                  color: ColorConstant.blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),

          //----------------- SPACE ------------------- -/
          const SizedBox(height: 10,),

          //--------- DESRIPTION INPUT ---------- -/
          Text(
            'Insira o Código',
            style: GoogleFonts.quicksand(
                color: ColorConstant.blackColor,
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),
          ),


          //----------------- SPACE ------------------- -/
          const SizedBox(height: 10,),


          //----------- INPUTS CODE ------------- -/
          GestureDetector(
            onTap: () {},
            child: Container(
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: <Widget>[
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45),
                      child: PinPut(
                        fieldsCount: 4,
                        textStyle: TextStyle(fontSize: 25.0, color: Colors.white),
                        eachFieldWidth: 40.0,
                        eachFieldHeight: 55.0,
                        focusNode: _pinFocusNode,
                        controller: _pinTextEditingController,
                        submittedFieldDecoration: pinOTPCodeDecoration,
                        selectedFieldDecoration: pinOTPCodeDecoration,
                        followingFieldDecoration: pinOTPCodeDecoration,
                        pinAnimationType: PinAnimationType.rotation,
                        onSubmit: (pin) async {
                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: verificationCode!, smsCode: pin))
                                .then((value) {
                              if (value.user != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => WelcomeScreen(telefone: widget.telefoneCliente,),
                                  ),
                                );
                              }
                            });
                          } catch (e) {
                            FocusScope.of(context).unfocus();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("OTP Inválido"),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),

          //----------------- SPACE ------------------- -/
          const SizedBox(height: 10,),

          //----------- BUTTON CHECK & RESEND ----------- -/
          _buttonCheckResend(),

        ],
      ),
    );
  }


  //********************* CHECK & RESEND ********************** */
  _buttonCheckResend(){
    return Column(
      children: [

        //------------------------ BUTTON REGISTER --------------- -/
        InkWell(
          onTap: (){
            setState(() {
              if (textEditingController.text == null) {
                null;
              } else if (currentText == widget.codigoDeConfirmacao.toString()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => WelcomeScreen(telefone: widget.telefoneCliente,),
                  ),
                );
              }
            });
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
                  'Confirmar',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: ColorConstant.whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ),

        //------------------------- SPACE ------------------------- -/
        const SizedBox(height: 20,),

        //--------------- BUTTON LOGIN -------------- -/
        InkWell(
          onTap: (){

          },
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: ColorConstant.colorSecundary,
                borderRadius: BorderRadius.circular(20),
              ),
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.width / 1.2,
              child: Center(
                child: Text(
                  'Reenviar',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: ColorConstant.textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
