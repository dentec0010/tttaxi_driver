import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/color_constant.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            'Mensagem',
            style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorConstant.whiteColor
            ),
          ),
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: const BoxDecoration(
                color: ColorConstant.transparent,
              ),
              child: const Center(
                  child: Text(
                      "Olá, eu sou a Julia, amei o tt-taxi, muito confortavel e irei"
                          "recomendar as minhas amigas..."
                  )
              )
          ),

          Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height / 14,
              width: MediaQuery.of(context).size.width/1.8,
              decoration: BoxDecoration(
                  color: ColorConstant.colorPrimary,
                  border: Border.all(color: Colors.black45, width: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: const Radius.circular(10),
                  )
              ),
              child: const Center(
                child: const Text(
                  "muito obrigado, esperando as suas amigas..."
                ),
              ),
          ),

          Container(
            //margin: EdgeInsets.only(bottom: 50),
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.black45, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(30),
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.emoji_emotions_outlined,
                    size: 20,
                    color: Colors.black,
                  ),

                  Center(
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: 'Escreva uma mensagem',
                        hintStyle: GoogleFonts.quicksand(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      // obscureText: true,
                    ),
                  ),

                  const Icon(
                    Icons.mic_rounded,
                    size: 20,
                    color: Colors.black,
                  ),
                ],
              )
          ),

        ],
      ),
    );
  }
}
