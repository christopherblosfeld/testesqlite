import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testesqlite/UsuariosListItem.dart';
import 'main.dart';
import 'database_helper.dart';

class UsuariosPage extends StatefulWidget {
  UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

Future<List<Usuario>> buscaUsuarios() async {
  // BUSCA DADOS DO SQLITE
  final todasLinhas = await DatabaseHelper.instance.queryAllRows();

  // LISTA DE USUARIOS VAZIA
  List<Usuario> listaUsuarios = [];

  // LOOP PARA ALIMENTAR A LISTA
  for (var e in todasLinhas) {
    listaUsuarios.add(
      Usuario(
        id: e['id'],
        idade: int.tryParse(e['idade'].toString()),
        nome: e['nome'],
      ),
    );
  }
  // RETORNO DO METODO COM TODOS OS USUARIOS DO SQLITE
  return listaUsuarios;
}

class Usuario {
  int? id;
  String? nome;
  int? idade;

  Usuario({this.id, this.nome, this.idade});
}

@override
class _UsuariosPageState extends State<UsuariosPage> {
  List<Usuario> listaUsuarios = [];

  //void initState() {
  //  super.initState();

  // ISSO É IGUAL AO ONCREATE OU ONACTIVE DO DELPHI, ASSIM QUE A TELA ABRIR JA VAI CONSULTAR OS DADOS, ASSIM VOCE NÃO PRECISA DE UM BOTAO PARA ISSO
  //  setState(() async {
  //    _consultar();
  //  });
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
                child: const Text(
                  'Consultar dados',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  await _consultar();
                  setState(() {});
                }),
            ListView(
              shrinkWrap: true,
              children: [
                for (Usuario usuario in listaUsuarios)
                  UsuarioListItem(usuario: usuario, onDelete: onDelete)
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _consultar() async {
    // final todasLinhas = await dbHelper.queryAllRows();
    // print('Consulta todas as linhas:');
    // todasLinhas.forEach((row) => print(row));
    listaUsuarios = await buscaUsuarios();
  }

  void onDelete(Usuario usuario) {
    setState(() {
      listaUsuarios.remove(usuario);
    });
  }
}
