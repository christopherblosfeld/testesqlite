import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'UsuariosPage.dart';

class UsuarioListItem extends StatelessWidget {
  const UsuarioListItem({
    Key? key,
    required this.usuario,
  }) : super(key: key);

  final Usuario usuario;
  //final Function(Usuario) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey[200],
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(usuario.id.toString()),
              Text(usuario.nome.toString()),
              Text(usuario.idade.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  )),
              
            ],
          ),
        ));
  }
}
