import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color_constant.dart';

class ListOfWay extends StatelessWidget {
  const ListOfWay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorConstant.transparent,
        //border: Border.all(width: 1, color: Colors.black38),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Golf-2',
            style: GoogleFonts.quicksand(
                color: ColorConstant.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.normal
            ),
          ),

          //-------------------- ICON STATE ---------------- -/
          Text(
            'Multiperfil',
            style: GoogleFonts.quicksand(
                color: ColorConstant.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.normal
            ),
          ),

          Text(
            '1h',
            style: GoogleFonts.quicksand(
                color: ColorConstant.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.normal
            ),
          ),
        ],
      ),
    );
  }
}
