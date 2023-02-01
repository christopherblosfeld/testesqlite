import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'database_helper.dart';

class UsuariosPage extends StatefulWidget {
  UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

@override
class _UsuariosPageState extends State<UsuariosPage> {
  final dbHelper = DatabaseHelper.instance;
  List<dynamic> listUsers = [];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ElevatedButton(
                child: Text(
                  'Consultar dados',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    _consultar();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _consultar() async {
    final todasLinhas = await dbHelper.queryAllRows();
    print('Consulta todas as linhas:');
    for (var row in todasLinhas) {
      listUsers.add(row);
    }
    return todasLinhas;
  }
}
