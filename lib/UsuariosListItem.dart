import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'UsuariosPage.dart';

class UsuarioListItem extends StatefulWidget {
  const UsuarioListItem({
    Key? key,
    required this.usuario,
    required this.onDelete,
  }) : super(key: key);

  final Usuario usuario;
  final Function(Usuario) onDelete;

  @override
  State<UsuarioListItem> createState() => _UsuarioListItemState();
}

class _UsuarioListItemState extends State<UsuarioListItem> {
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
              Text(widget.usuario.id.toString()),
              Text(widget.usuario.nome.toString()),
              Text(widget.usuario.idade.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  )),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    print('teste');
                    if (alertPergunta(context, 'Remover usuário',
                            'Tem certeza que deseja remover?') ==
                        true) {}
                  });
                },
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
}
