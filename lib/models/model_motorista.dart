

class ModelMotorista {
  String id_motorista;
  String nome_motorista;
  String sobrenome_motorista;
  String telefone_motorista;
  String email_motorista;
  String bi_motorista;
  String passaport_motorista;
  String password_motorista;
  String id_estado;


  ModelMotorista(
      {
        required this.id_motorista,
        required this.nome_motorista,
        required this.sobrenome_motorista,
        required this.telefone_motorista,
        required this.email_motorista,
        required this.bi_motorista,
        required this.passaport_motorista,
        required this.password_motorista,
        required this.id_estado,
      }
      );

  factory ModelMotorista.fromJson(Map<String, dynamic> json) {
    return ModelMotorista(
      id_motorista: json['id_motorista'] as String,
      nome_motorista: json['nome_motorista'] as String,
      sobrenome_motorista: json['sobrenome_motorista'] as String,
      telefone_motorista: json['telefone_motorista'] as String,
      email_motorista: json['email_motorista'] as String,
      bi_motorista: json['bi_motorista'] as String,
      passaport_motorista: json['passaport_motorista'] as String,
      password_motorista: json['password_motorista'] as String,
      id_estado: json['id_estado'] as String,
    );
  }

}