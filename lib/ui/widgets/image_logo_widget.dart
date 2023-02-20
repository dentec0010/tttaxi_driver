import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color_constant.dart';


class ImageLogoWidget extends StatelessWidget {
  const ImageLogoWidget({Key? key}) : super(key: key);

  //****************** WIDGET ROOT ******************* */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        //--------------- IMAGE LOGO ---------------- -/
        Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            image: const DecorationImage(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.fill
            ),
          ),
        ),

        //------------------- SPACE ------------------- -/
        //const SizedBox(height: 10,),


        //------------------ NAME APP ----------------- -/
       /* Text(
          'T-T TÁXI',
          style: GoogleFonts.quicksand(
            fontSize: 40,
            color: ColorConstant.textColor,
          ),
        ),*/
      ],
    );
  }
}
