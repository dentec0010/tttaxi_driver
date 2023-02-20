import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tttaxi_driver/constants/color_constant.dart';
import '../widgets/image_logo_widget.dart';
import 'onboarding_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(const Duration(seconds: 6)).then((_){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const OnboardingScreen()));
    });
  }


  //************************ WIDGET ROOT ******************** */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //------------------------ IMAGE LOGO ------------------- -/
              ImageLogoWidget(),
              SizedBox(height: 20,),
              Center(
                child: Text(
                  'T-T TÁXI',
                  style: GoogleFonts.quicksand(
                      color: ColorConstant.blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
              Center(
                child: Text(
                  'MOTORISTA',
                  style: GoogleFonts.quicksand(
                      color: ColorConstant.blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
