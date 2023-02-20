import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tttaxi_driver/ui/screens/intro_screen.dart';
import 'package:tttaxi_driver/ui/screens/payment_screen.dart';

import 'providers/location_provider.dart';
import 'services/notification.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationProvider>(
            create: (_) => LocationProvider()),
        ChangeNotifierProvider<NotificationService>(
            create: (_) => NotificationService()
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TTT-Taxi Driver Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: PaymentScreen(nome: "nome", sobrenome: "sobrenome", telefone: "telefone", tipo: "tipo", origem: "origem", destino: "destino", valor: "valor", telefoneMotorista: "telefoneMotorista", idCorrida: "idCorrida"),
        home: const IntroScreen(),
      ),
    );
  }
}

