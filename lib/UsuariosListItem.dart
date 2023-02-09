import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'UsuariosPage.dart';
import 'database_helper.dart';

class UsuarioListItem extends StatefulWidget {
  const UsuarioListItem({
    Key? key,
    required this.usuario,
    required this.deletaUsuario,
  }) : super(key: key);

  final Usuario usuario;
  final Function deletaUsuario;

  @override
  State<UsuarioListItem> createState() => _UsuarioListItemState();
}

class _UsuarioListItemState extends State<UsuarioListItem> {
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  )),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => widget.deletaUsuario(),
              )
            ],
          ),
        ));
  }

  static alert(BuildContext context, String titulo, String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
  }

  static Future<bool> alertPergunta(
      BuildContext context, String titulo, String msg) async {
    bool ret = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                ret = true;
                Navigator.pop(context, true);
              },
              child: const Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                ret = false;
                Navigator.pop(context, false);
              },
              child: const Text('Não'),
            )
          ],
        );
      },
    );
    return ret;
  }

  void _deletar(int iduser) async {
    final id = await DatabaseHelper.instance.delete(iduser);
    //final linhaDeletada = await DatabaseHelper.instance.delete(iduser);
    print('Linha deletada: linha $id');
  }
}
