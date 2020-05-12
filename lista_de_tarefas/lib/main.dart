import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



  List _toDOList = [];
  final _toDoController = TextEditingController();
  
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

// * raliza a leitura das tarefas armazenadas
  @override
  void initState(){
    super.initState();
    _readData().then((data){
      setState(() {
        _toDOList = json.decode(data);
      });
    });
  }  

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDOList.add(newToDo);
      _saveData();
    });
  }

  Future<Null> _refresh() async{
     await Future.delayed(Duration(seconds: 2));
    setState(() {
    _toDOList.sort((a, b){
      if(a["ok"] && !b["ok"]) return 1;
      else if(!a["ok"] && b["ok"]) return -1;
        else  return 0;
    });
    _saveData();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Column(children: <Widget>[
        // * Imput
        Container(
          padding: EdgeInsets.fromLTRB(17, 1, 7, 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _toDoController,
                  decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.green)),
                ),
              ),
              RaisedButton(
                  color: Colors.green,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addToDo)
            ],
          ),
        ),
        // * lista (output)
        Expanded(
          child: RefreshIndicator(
            child:
              ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: _toDOList.length,
              itemBuilder:  buildItem),
              onRefresh: _refresh,
              ),
        )
      ]),
    );
  }
  Widget buildItem (context, index) {
                return Dismissible(
                  key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment(-0.9, 0),
                      child: Icon(Icons.delete, color: Colors.white,),
                      ),
                  ),
                  direction: DismissDirection.startToEnd,
                  child: 
                  CheckboxListTile(
                    onChanged: (check){
                      setState(() {
                        _toDOList[index]["ok"] = check;
                        _saveData();
                      });
                    },
                    title: Text(_toDOList[index]["title"]),
                    value: _toDOList[index]["ok"],
                    secondary: CircleAvatar(
                      child: Icon(
                          _toDOList[index]["ok"] ? Icons.check : Icons.error),
                    ),
                  ),
                  onDismissed: (direction){
                    setState(() {
                      _lastRemoved = Map.from(_toDOList[index]);
                    _lastRemovedPos = index;
                    _toDOList.removeAt(index);

                    _saveData();
                    final snack = SnackBar(
                      content: Text("A tarefa ${_lastRemoved["title"]} foi removida!"),
                      action: SnackBarAction(
                        label: "Desfazer",
                        onPressed: (){
                          setState(() {
                            _toDOList.insert(_lastRemovedPos, _lastRemoved);
                          _saveData();
                          });
                        },
                        ),
                        duration: Duration(seconds: 4),
                      );
                      Scaffold.of(context).removeCurrentSnackBar();   
                      Scaffold.of(context).showSnackBar(snack);
                    });
                  },
                );
              }
            
  // ! funções para criar e salvar arquivo
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDOList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
