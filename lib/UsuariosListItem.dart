import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'UsuariosPage.dart';
import 'database_helper.dart';

class UsuarioListItem extends StatefulWidget {
  const UsuarioListItem({
    Key? key,
    required this.usuario,
    required this.deletaUsuario,
    required this.atualizaUsuario,
    //required this.exibeAlerta,
  }) : super(key: key);

  final Usuario usuario;
  final Function deletaUsuario;
  final Function atualizaUsuario;
  //final Function exibeAlerta;

  @override
  State<UsuarioListItem> createState() => _UsuarioListItemState();
}

class _UsuarioListItemState extends State<UsuarioListItem> {
  final TextEditingController novoNome = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nomeKey = GlobalKey<FormFieldState>();
  final _idadeKey = GlobalKey<FormFieldState>();
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
              Text(widget.usuario.id.toString()),
              Text(widget.usuario.nome.toString()),
              Text(widget.usuario.idade.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  )),
              IconButton(
                  icon: const Icon(Icons.edit), //Botão de editar
                  onPressed: () {
                    //widget.exibeAlerta();
                    widget.atualizaUsuario();
                  }),
              IconButton(
                icon: Icon(Icons.delete), //Botão de deletar
                onPressed: () => widget.deletaUsuario(),
              ),
            ],
          ),
        ));
  }

  String? _validaNome(String? texto) {
    if (texto == null || texto.isEmpty) {
      return 'Informe um nome!';
    }
  }
}
