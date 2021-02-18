import 'package:demo_pedidos/modules/Home/home.dart';
import 'package:demo_pedidos/modules/pastel_order_detail/pastel_order_detail.dart';
import 'package:demo_pedidos/modules/pastel_order_detail/provider/pastel_provider.dart';
import 'package:demo_pedidos/modules/pizza_order/pizza_order_details.dart';
import 'package:demo_pedidos/modules/provider/pizza_animation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PizzaAnimationProvider()),
        ChangeNotifierProvider(create: (_) => PastelProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          initialRoute: '/',
          routes: {
            '/': (BuildContext context) => HomePedidos(),
            'pizza': (BuildContext context) => PizzaOrderDetails(),
            'pastel': (BuildContext context) => PastelOrderDetails(),
          }),
    );
  }
}
