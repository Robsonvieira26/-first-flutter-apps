import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=cc334d13";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.yellowAccent,
      primaryColor: Colors.yellow,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
        focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.yellowAccent)),
        hintStyle: TextStyle(color: Colors.yellowAccent),
      )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double euro;
  double usddolar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Conversor",
              style: TextStyle(
                color: Colors.black,
              )),
          backgroundColor: Colors.yellowAccent,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.yellowAccent, fontSize: 25),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro ao carregar dados",
                      style:
                          TextStyle(color: Colors.yellowAccent, fontSize: 25),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    usddolar=snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,color: Colors.yellowAccent, size: 100),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Reais",
                              labelStyle: TextStyle(color: Colors.yellowAccent),
                              border: OutlineInputBorder(),
                              prefixText: "R\$ ",
                            ),
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Divider(),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Dolares",
                              labelStyle: TextStyle(color: Colors.yellowAccent),
                              border: OutlineInputBorder(),
                              prefixText: "\$ ",
                            ),
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Divider(),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Euros",
                              labelStyle: TextStyle(color: Colors.yellowAccent),
                              border: OutlineInputBorder(),
                              prefixText: "€ ",
                            ),
                            style: TextStyle(color: Colors.yellowAccent),
                          )
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}
