import 'package:flutter/material.dart';

class HomePedidos extends StatefulWidget {
  HomePedidos({Key key}) : super(key: key);

  @override
  _HomePedidosState createState() => _HomePedidosState();
}

class _HomePedidosState extends State<HomePedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2dcc8f),
        title: Text(
          "Demo Pedidos",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.local_pizza),
              title: Text('Pizza'),
              trailing: Icon(Icons.arrow_right),
              onTap: () => Navigator.pushNamed(context, 'pizza'),
            ),
            ListTile(
              leading: Icon(Icons.cake),
              title: Text('Pastel'),
              trailing: Icon(Icons.arrow_right),
              onTap: () => Navigator.pushNamed(context, 'pastel'),
            )
          ],
        ),
      ),
    );
  }
}
