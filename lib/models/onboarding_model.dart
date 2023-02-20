import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String image;
  final String desc;

  OnboardingModel(
      {required this.title, required this.image, required this.desc});
}

List<OnboardingModel> contents = [
  OnboardingModel(
    title: "Seja Motorista",
    image: "assets/images/seja_motorista.jpg",
    desc: "Ganhe Dinheiro levando passageiros.",
  ),
  OnboardingModel(
    title: "Produção em Tempo Real",
    image: "assets/images/ver_producao.jpg",
    desc: "A cada minutos e hora visualize a sua produção.",
  ),
  OnboardingModel(
    title: "Gerência de Corridas",
    image: "assets/images/patrao.jpg",
    desc: "Gerêncie cada corrida, sendo o seu próprio patrão.",
  ),
];