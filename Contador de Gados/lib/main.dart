import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "Contador de gados", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _gados = 0;
  String _gadosText= "Qtd normal de gados";

  void _changeGados(int delta) {
    setState(() {
      _gados+=delta;
      if(_gados>=10)
        _gadosText="aMuuuh!";
      else if(_gados < 0)
        _gadosText="Cade o paulo?!";
      else
        _gadosText= "Qtd normal de gados";

    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset("images/pasto.png", fit: BoxFit.cover, height: 1000),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Gados: $_gados",
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      "+1",
                      style: TextStyle(color: Colors.white, fontSize: 45),
                    ),
                    onPressed: () {
                      _changeGados(1);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      "-1",
                      style: TextStyle(color: Colors.white, fontSize: 45),
                    ),
                    onPressed: () {
                      _changeGados(-1);
                    },
                  ),
                ),
              ],
            ),
            Text(
              _gadosText,
              style:
              TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            )
          ],
        )
      ],
    );
  }
}
