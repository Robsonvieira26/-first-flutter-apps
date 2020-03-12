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
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellowAccent)),
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
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();
  final libraController = TextEditingController();

  double euro;
  double usddolar;
  double bitcoin;
  double libra;

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    bitcoinController.text = "";
    libraController.text = "";
  }

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/usddolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    libraController.text= (real/libra).toStringAsFixed(2);
    bitcoinController.text =(real/bitcoin).toStringAsFixed(8);
  }

  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * usddolar).toStringAsFixed(2);
    euroController.text = ((dolar * usddolar) / euro).toStringAsFixed(2);
    libraController.text=((dolar * usddolar) / libra).toStringAsFixed(2);
    bitcoinController.text=((dolar * usddolar) / bitcoin).toStringAsFixed(8);
  }

  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro) / usddolar).toStringAsFixed(2);
    libraController.text = ((euro * this.euro) / libra).toStringAsFixed(2);
    bitcoinController.text = ((euro * this.euro) / bitcoin).toStringAsFixed(8);
  }

  void _bitcoinChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double bit = double.parse(text);
    realController.text = (bit*bitcoin).toStringAsFixed(2);
    euroController.text = ((bit*bitcoin)/euro).toStringAsFixed(2);
    dolarController.text =((bit*bitcoin)/usddolar).toStringAsFixed(2);
    libraController.text =((bit*bitcoin)/libra).toStringAsFixed(2);
  }

  void _libraChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double libra = double.parse(text);
    realController.text = (libra*this.libra).toStringAsFixed(2);
    euroController.text = ((libra*this.libra)/euro).toStringAsFixed(2);
    dolarController.text =((libra*this.libra)/usddolar).toStringAsFixed(2);
    bitcoinController.text =((libra*this.libra)/bitcoin).toStringAsFixed(5);
  }

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
                    usddolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    bitcoin =snapshot.data["results"]["currencies"]["BTC"]["buy"];
                    libra=snapshot.data["results"]["currencies"]["GBP"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              color: Colors.yellowAccent, size: 100),
                          buildTextField("Reais", "R\$ ",realController,_realChanged),
                          Divider(),
                          buildTextField("Dolares", "\$ ",dolarController,_dolarChanged),
                          Divider(),
                          buildTextField("Euros", "€ ",euroController,_euroChanged),
                          Divider(),
                          buildTextField("Libras esterlinas", "£ ",libraController,_libraChanged),
                          Divider(),
                          buildTextField("BitCoin","Ƀ ",bitcoinController,_bitcoinChanged),

                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(String label, String prefix,TextEditingController ctrl,Function func) {
  return TextField(
    controller: ctrl,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.yellowAccent),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(color: Colors.yellowAccent),
    onChanged: func,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
