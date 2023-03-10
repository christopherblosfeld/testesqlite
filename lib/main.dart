import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:testesqlite/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'UsuariosPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQFlite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

@override
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // referencia nossa classe single para gerenciar o banco de dados
  final dbHelper = DatabaseHelper.instance;
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nomeKey = GlobalKey<FormFieldState>();
  final _idadeKey = GlobalKey<FormFieldState>();

  // layout da homepage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            alignment: Alignment.centerRight,
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                print('teste');
                Navigator.push(
                    //Navegar para a página de usuários cadastrados
                    context,
                    MaterialPageRoute(builder: (context) => UsuariosPage()));
              });
            },
          )
        ],
        title: Text('Exemplo de CRUD básico'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: nomeController,
                  validator: _validaNome,
                  maxLength: 10,
                  key: _nomeKey,
                  decoration: const InputDecoration(
                    labelText: 'Digite um nome',
                    hintText: 'Exemplo: chr.Joseph',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  maxLength: 2,
                  controller: idadeController,
                  keyboardType: TextInputType.number,
                  validator: _validaIdade,
                  key: _idadeKey,
                  decoration: const InputDecoration(
                    labelText: 'Digite uma idade',
                    hintText: 'Exemplo: chr.Joseph',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                ElevatedButton(
                  child: const Text(
                    'Inserir dados',
                    style: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    setState(() {
                      if (_nomeKey.currentState?.validate() == false) {
                        return;
                      }
                      if (_idadeKey.currentState?.validate() == false) {
                        return;
                      }
                      _inserir();
                      print('inserido');
                      nomeController.clear();
                      idadeController.clear();
                    });
                  },
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // métodos dos Buttons
  void _inserir() async {
    // linha para incluir
    Map<String, dynamic> row = {
      DatabaseHelper.columnNome: nomeController.text,
      DatabaseHelper.columnIdade: idadeController.text,
    };
    final id = await dbHelper.insert(row);
    print('linha inserida id: $id');
  }

  void _consultar() async {
    final todasLinhas = await dbHelper.queryAllRows();
    print('Consulta todas as linhas:');
    todasLinhas.forEach((row) => print(row));
  }

  void _atualizar() async {
    // linha para atualizar
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnNome: nomeController,
      DatabaseHelper.columnIdade: idadeController,
    };
    final linhasAfetadas = await dbHelper.update(row);
    print('atualizadas $linhasAfetadas linha(s)');
  }

  void _deletar() async {
    // Assumindo que o numero de linhas é o id para a última linha
    final id = await dbHelper.queryRowCount();
    final linhaDeletada = await dbHelper.delete(id!);
    print('Deletada(s) $linhaDeletada linha(s): linha $id');
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
}
