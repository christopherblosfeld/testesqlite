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
  //int? idade;
  final _formKey = GlobalKey<FormState>();
  final _nomeKey = GlobalKey<FormFieldState>();
  final _idadeKey = GlobalKey<FormFieldState>();
  //static String? nome;

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
                  itemBuilder: (context, index) {
                    return UsuarioListItem(
                      usuario: listaUsuarios[index],
                      deletaUsuario: () async {
                        await _deletar(listaUsuarios[index].id!);
                        await _consultar();
                        setState(() {});
                      },
                      atualizaUsuario: () async {
                        try {
                          int idade = await alert(context, 'Atualizar dados',
                              'Informe os novos dados');
                          //if (nome == null || nome.isEmpty) {
                          //  return;
                          // }

                          await _atualizar(
                              listaUsuarios[index].id!, novoNome.text, idade);
                          await _consultar();
                          setState(() {});
                          print(novoNome.text);
                          print(idade.toString());
                          novoNome.clear();
                        } catch (e) {
                          print('deu ruim');
                          print(e);
                        }
                      },
                      //}
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

  alert(BuildContext context, String titulo, String msg) async {
    String? nome;
    String? idade;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo, style: TextStyle(color: Colors.red)),
          content: Text(msg),
          actions: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: _nomeKey,
                    controller: novoNome,
                    validator: _validaNome,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: novaidade,
                    key: _idadeKey,
                    validator: _validaIdade,
                    decoration: const InputDecoration(
                      labelText: 'Idade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_nomeKey.currentState?.validate() == false ||
                          _idadeKey.currentState?.validate() == false) {
                        return;
                      } else {
                        int idade = int.tryParse(novaidade.text) ?? (99);
                        //nome = novoNome.text;
                        //idade = novaidade.text;
                        //int.tryParse(novaidade.text) ?? (99);
                        Navigator.of(context).pop([novoNome.text, idade]);
                        //Navigator.pop(context, nome);
                      }
                    },
                    child: const Text('Ok'),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );

    return idade;
  }

  Future<void> _deletar(int iduser) async {
    final id = await DatabaseHelper.instance.delete(iduser);
    //final linhaDeletada = await DatabaseHelper.instance.delete(iduser);
    print('Linha deletada: linha $id');
  }

  Future<void> _atualizar(int iduser, String nome, int idade) async {
    // linha para atualizar
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: iduser,
      DatabaseHelper.columnNome: nome,
      DatabaseHelper.columnIdade: idade,
    };
    final linhasAfetadas = await DatabaseHelper.instance.update(row);
    print('atualizadas $linhasAfetadas linha(s)');
  }

  String? _validaNome(String? texto) {
    if (texto == null || texto.isEmpty) {
      return 'Informe um nome!';
    }
  }

  String? _validaIdade(String? idade) {
    if (idade == null || idade.isEmpty) {
      return 'Informe uma idade!';
    }
  }

  Future<void> _consultar() async {
    listaUsuarios = await buscaUsuarios();
  }

  //void onDelete(Usuario usuario) {
  //  setState(() {
  //    listaUsuarios.remove(usuario);
  //  });
  // }
}
