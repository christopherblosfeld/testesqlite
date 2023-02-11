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
  final TextEditingController novoNome = TextEditingController();
  final TextEditingController novaidade = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nomeKey = GlobalKey<FormFieldState>();

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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  child: const Text(
                    'Consultar DADOS',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    await _consultar();
                    setState(() {});
                  }),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listaUsuarios.length,

                  // ISSO AQUI É UM CONSTRUTOR DE WIDGETS, BASEADO EM CONTEXTO E UM CONTADOR(INDEX) QUE É DEFINIDO PELO ITEMCOUNT DO WIDGET,
                  // ENTÃO ELE VAI FAZER UM "FOR" NESSE INDEX, E NISSO VAI CONTRUIR OS WIDGETS
                  // PODE PARECER QUE NÃO FAZ DIFERENÇA, MAS ESSE CARA AI SÓ CONSTROI O QUE TIVER NO SCROLL DELE, ENTÃO O QUE TA PRA CIMA OU PRA BAIXO
                  // NAO É CONSTRUIDO, ASSIM ECONOMIZA MEMORIA RAM DO DISPOSITOVO E DEIXA O APP MAIS LEVE
                  itemBuilder: (context, index) {
                    return UsuarioListItem(
                      usuario: listaUsuarios[index],
                      deletaUsuario: () async {
                        await _deletar(listaUsuarios[index].id!);
                        alert(context, 'exclusão', 'a tarefa será excluída');
                        await _consultar();
                        setState(() {});
                      },
                      atualizaUsuario: () async {
                        alert(context, 'Alterar', 'Informe o novo nome');

                        await _atualizar(
                            listaUsuarios[index].id!,
                            novoNome
                                .text); //Passando o novo nome e a nova idade após o usuario clicar em atualizar.
                        await _consultar();
                        setState(() {
                          if (_nomeKey.currentState?.validate() == true) {
                            return;
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deletar(int iduser) async {
    final id = await DatabaseHelper.instance.delete(iduser);
    //final linhaDeletada = await DatabaseHelper.instance.delete(iduser);
    print('Linha deletada: linha $id');
  }

  Future<void> _atualizar(int iduser, String nome) async {
    // linha para atualizar
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: iduser,
      DatabaseHelper.columnNome: nome,
      DatabaseHelper.columnIdade: 15,
    };
    final linhasAfetadas = await DatabaseHelper.instance.update(row);
    print('atualizadas $linhasAfetadas linha(s)');
  }

  alert(BuildContext context, String titulo, String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: <Widget>[
            Form(
              key: _formKey,
              child: TextFormField(
                key: _nomeKey,
                controller: novoNome,
                validator: _validaNome,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
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

  String? _validaNome(String? texto) {
    if (texto == null || texto.isEmpty) {
      return 'Informe um nome!';
    }
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
