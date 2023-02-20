import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/color_constant.dart';


class RegisterTwoWidget extends StatefulWidget {
  const RegisterTwoWidget({Key? key,}) : super(key: key);

  @override
  State<RegisterTwoWidget> createState() => _RegisterTwoWidgetState();
}

class _RegisterTwoWidgetState extends State<RegisterTwoWidget> {


  //********************** WIDGET ROOT ********************** */
  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: Column(

        //mainAxisAlignment: MainAxisAlignment.center,
        children:  [

          //------------------- INPUT PHOTO -------------------- -/

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 2.5,
                decoration: BoxDecoration(
                  color: ColorConstant.whiteColor,
                  borderRadius: BorderRadius.circular(300),
                  border: Border.all(width: 1, color: Colors.black38),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.fill
                  ),
                ),
              ),
            ),
          ),

          //----------------- SPACE ------------------- -/
          const SizedBox(height: 10,),


          Container(
            width: MediaQuery.of(context).size.width / 1.12,
            height: !isKeyboard ? MediaQuery.of(context).size.height / 3
                : MediaQuery.of(context).size.height / 1.5,
            child: ListView(
              children: [

                //----------- INPUT NAME ---------------- -/
                Text(
                  'T Táxi Company',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: ColorConstant.blackColor,
                  ),
                ),

                //----------------- SPACE ------------------- -/
                const SizedBox(height: 10,),

                //----------- INPUT NUMBER ---------------- -/
                Text(
                  '9XX XXX XXX',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: ColorConstant.blackColor,
                  ),
                ),

                //----------------- SPACE ------------------- -/
                const SizedBox(height: 10,),

                Text(
                  'ttaxi@gmail.com',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: ColorConstant.blackColor,
                  ),
                ),

                //----------------- SPACE ------------------- -/
                const SizedBox(height: 10,),

                //----------- INPUT ADRESS ---------------- -/
                Text(
                  'Rua Pedro de Castro Vandunem Loy',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: ColorConstant.blackColor,
                  ),
                ),

                //----------------- SPACE ------------------- -/
                const SizedBox(height: 10,),

                //----------- INPUT BI ---------------- -/
                Text(
                  '0216985486LA015',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: ColorConstant.blackColor,
                  ),
                ),

              ],
            ),
          ),

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

          //------------------- SPACE ---------------- -/
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}
