import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:testesqlite/database_helper.dart';
import 'package:sqflite/sqflite.dart';

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

  // layout da homepage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplo de CRUD básico'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Digite um nome',
                  hintText: 'Exemplo: chr.Joseph',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 18),
              TextFormField(
                controller: idadeController,
                decoration: InputDecoration(
                  labelText: 'Digite uma idade',
                  //hintText: 'Exemplo: chr.Joseph',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              ElevatedButton(
                child: Text(
                  'Inserir dados',
                  style: const TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  setState(() {
                    _inserir();
                    print('inserido');
                  });
                },
              ),
              SizedBox(
                height: 8,
              ),
              ElevatedButton(
                child: Text(
                  'Consultar dados',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    _consultar();
                    _inserir();
                  });
                },
              ),
              SizedBox(
                height: 8,
              ),
              ElevatedButton(
                child: Text(
                  'Atualizar dados',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  _atualizar();
                },
              ),
              SizedBox(
                height: 8,
              ),
              ElevatedButton(
                child: Text(
                  'Deletar dados',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  _deletar();
                },
              ),
            ],
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
}
