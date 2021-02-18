import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:demo_pedidos/custom_widgets/btn_custom.dart';
import 'package:demo_pedidos/modules/pastel_order_detail/provider/pastel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

const _pizzaCartSize = 48.0;

class PastelOrderDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pastel',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add_shopping_cart_outlined,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 50,
              left: 10,
              right: 10,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                child: SingleChildScrollView(
                  child: Container(
                      //color: Colors.red,
                      height: MediaQuery.of(context).size.height - 200,
                      width: MediaQuery.of(context).size.height - 20,
                      child: _PastelDetails()),
                ),
              ),
            ),
            Positioned(
              bottom: -5,
              height: 50,
              width: MediaQuery.of(context).size.width,
              //left: MediaQuery.of(context).size.width / 2 - _pizzaCartSize / 2,
              child: _ButtonCustom(),
            )
          ],
        ));
  }
}

class _PastelDetails extends StatefulWidget {
  @override
  __PastelDetailsState createState() => __PastelDetailsState();
}

class __PastelDetailsState extends State<_PastelDetails>
    with SingleTickerProviderStateMixin {
  final _listingredients = <String>[];
  final _listingredientsUnit = <String>[];

  //zoom
  double _scale = 1.0;
  double _previousScale = 1.0;

  AnimationController animationController;

  final _notifierFocused = ValueNotifier(false);

  TextEditingController controller = TextEditingController();

  Color currentColor = Colors.limeAccent;
  List<Color> currentColors = [Colors.limeAccent, Colors.green];

  int totalUnitario = 15;
  int total = 15;

  String textoPersonalizado = '';

  int count = 1;

  List<Animation> _animationList = <Animation>[];
  BoxConstraints _pizzaConstraints;
  List<List<Offset>> listOffset = [
    [
      Offset(0.2, 0.2),
      Offset(0.6, 0.2),
      Offset(0.4, 0.25),
      Offset(0.5, 0.23),
      Offset(0.4, 0.65),
    ],
    [
      Offset(0.2, 0.35),
      Offset(0.65, 0.35),
      Offset(0.3, 0.23),
      Offset(0.5, 0.2),
      Offset(0.3, 0.5),
    ],
    [
      Offset(0.25, 0.5),
      Offset(0.65, 0.6),
      Offset(0.2, 0.3),
      Offset(0.4, 0.2),
      Offset(0.2, 0.6),
    ],
    [
      Offset(0.2, 0.65),
      Offset(0.65, 0.3),
      Offset(0.25, 0.25),
      Offset(0.45, 0.35),
      Offset(0.4, 0.65),
    ],
    [
      Offset(0.2, 0.35),
      Offset(0.65, 0.35),
      Offset(0.3, 0.23),
      Offset(0.5, 0.2),
      Offset(0.3, 0.5),
    ],
    [
      Offset(0.2, 0.65),
      Offset(0.65, 0.3),
      Offset(0.25, 0.25),
      Offset(0.45, 0.35),
      Offset(0.4, 0.65),
    ],
    [
      Offset(0.2, 0.2),
      Offset(0.6, 0.2),
      Offset(0.4, 0.25),
      Offset(0.5, 0.3),
      Offset(0.4, 0.65),
    ],
  ];

  Widget _buildIngredientsWidget() {
    List<Widget> elemnts = [];

    if (_animationList.isNotEmpty) {
      for (int i = 0; i < _listingredients.length; i++) {
        String ingredient = _listingredients[i];
        final ingredientWidget = Image.asset(
          'assets/${ingredient}_unit.png',
          height: 40,
        );
        List<Offset> listOffsetTemp = listOffset[i];
        for (int j = 0; j < listOffsetTemp.length; j++) {
          final animation = _animationList[j];
          final position = listOffsetTemp[j];
          final positionX = position.dx;
          final positionY = position.dy;

          if (i == _listingredients.length - 1) {
            double fromX = 0.0, fromY = 0.0;

            if (j < 1) {
              fromX = -_pizzaConstraints.maxWidth * (1 - animation.value);
            } else if (j < 2) {
              fromX = _pizzaConstraints.maxWidth * (1 - animation.value);
            } else if (j < 4) {
              fromY = -_pizzaConstraints.maxHeight * (1 - animation.value);
            } else {
              fromY = _pizzaConstraints.maxHeight * (1 - animation.value);
            }

            final opacity = animation.value;

            if (animation.value > 0) {
              elemnts.add(Opacity(
                opacity: opacity,
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(fromX + _pizzaConstraints.maxWidth * positionX,
                        fromY + _pizzaConstraints.maxHeight * positionY),
                  child: ingredientWidget,
                ),
              ));
            }
          } else {
            elemnts.add(Transform(
              transform: Matrix4.identity()
                ..translate(_pizzaConstraints.maxWidth * positionX,
                    _pizzaConstraints.maxHeight * positionY),
              child: ingredientWidget,
            ));
          }
        }
      }
      return Stack(
        children: elemnts,
      );
    }

    return SizedBox.fromSize();
  }

  void _buildIngredientsAnimation() {
    _animationList.clear();
    _animationList.add(CurvedAnimation(
        curve: Interval(0.0, 0.8, curve: Curves.decelerate),
        parent: animationController));

    _animationList.add(CurvedAnimation(
        curve: Interval(0.2, 0.8, curve: Curves.decelerate),
        parent: animationController));

    _animationList.add(CurvedAnimation(
        curve: Interval(0.4, 0.8, curve: Curves.decelerate),
        parent: animationController));

    _animationList.add(CurvedAnimation(
        curve: Interval(0.1, 0.7, curve: Curves.decelerate),
        parent: animationController));

    _animationList.add(CurvedAnimation(
        curve: Interval(0.3, 0.8, curve: Curves.decelerate),
        parent: animationController));
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int subtotal;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            _pizzaConstraints = constraints;
            return Center(
                child: ValueListenableBuilder<bool>(
              valueListenable: _notifierFocused,
              builder: (context, value, child) {
                final provider = Provider.of<PastelProvider>(context);
                int idText = provider.btnStyleText;
                Color color = provider.color;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width:
                      value ? constraints.maxWidth : constraints.maxWidth - 50,
                  height: value
                      ? constraints.maxHeight
                      : constraints.maxHeight - 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      DecoratedBox(
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                              blurRadius: 20.0,
                              color: Colors.grey.withOpacity(0.2),
                              offset: Offset(0.0, 5.0),
                              spreadRadius: 5.0),
                        ]),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset('assets/cakes/cake.png'),
                        ),
                      ),
                      Center(
                        child: Center(
                          child: GestureDetector(
                            onScaleStart: (ScaleStartDetails details) {
                              _previousScale = _scale;
                              setState(() {});
                            },
                            onScaleUpdate: (ScaleUpdateDetails details) {
                              _scale = _previousScale * details.scale;
                              setState(() {});
                            },
                            onScaleEnd: (ScaleEndDetails details) {
                              _previousScale = 1.0;
                              setState(() {});
                            },
                            child: Container(
                                color: Colors.transparent,
                                width: MediaQuery.of(context).size.width * 0.5,
                                //height: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform(
                                      alignment: FractionalOffset.center,
                                      transform: Matrix4.diagonal3(
                                          Vector3(_scale, _scale, _scale)),
                                      child: TyperAnimatedTextKit(
                                        isRepeatingAnimation: true,
                                        speed: Duration(milliseconds: 100),
                                        text: [
                                          textoPersonalizado,
                                        ],
                                        textStyle: TextStyle(
                                          color: color,
                                          fontSize: 30.0,
                                          fontFamily: idText == 1
                                              ? "Roboto"
                                              : idText == 2
                                                  ? "DancingScript"
                                                  : "ArchivoBlack",
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ));
          },
        )),
        Container(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                'Cantidad',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (count != 1 && count > 0) {
                          count--;

                          total = totalUnitario * count;
                        }
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text(
                    '$count',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        count++;
                        total = totalUnitario * count;
                      });
                    },
                    icon: Icon(Icons.add),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                      begin: Offset(0.0, 0.0),
                      end: Offset(0.0, animation.value)),
                ),
                child: child,
              ),
            );
          },
          child: Text(
            '$total USD',
            key: UniqueKey(),
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff2dcc8f)),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Costo',
          key: UniqueKey(),
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        SizedBox(
          height: 10,
        ),
        tipeText(),
        selectColor(),
        textCustom(),
        butom()
      ],
    );
  }

  Widget tipeText() {
    //1 normal
    //2 italic
    //3 negrita

    int idText = Provider.of<PastelProvider>(context).btnStyleText;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Provider.of<PastelProvider>(context, listen: false).btnStyleText =
                  1;
            },
            child: BtnCustom(
              text: 'normal',
              colorBtn: idText == 1 ? Colors.blue : Colors.white,
              colorText: idText == 1 ? Colors.white : Colors.blue,
            ),
          ),
          GestureDetector(
            onTap: () {
              Provider.of<PastelProvider>(context, listen: false).btnStyleText =
                  2;
            },
            child: BtnCustom(
              text: 'cursiva',
              colorBtn: idText == 2 ? Colors.blue : Colors.white,
              colorText: idText == 2 ? Colors.white : Colors.blue,
            ),
          ),
          GestureDetector(
            onTap: () {
              Provider.of<PastelProvider>(context, listen: false).btnStyleText =
                  3;
            },
            child: BtnCustom(
              text: 'negrita',
              colorBtn: idText == 3 ? Colors.blue : Colors.white,
              colorText: idText == 3 ? Colors.white : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget selectColor() {
    return FlatButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Seleccione un color',
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    BlockPicker(
                      pickerColor: currentColor,
                      onColorChanged: (color) {
                        Provider.of<PastelProvider>(context, listen: false)
                            .color = color;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancelar')),
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('ok')),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Text(
        'Elegir color del texto',
        style: TextStyle(color: Color(0xff2dcc8f)),
      ),
    );
  }

  Widget butom() {
    return GestureDetector(
        onTap: () {
          if (controller.text != null && controller.text != "") {
            setState(() {
              _notifierFocused.value = true;
              textoPersonalizado = controller.text;
            });
          }
        },
        child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xff2dcc8f)),
            child: Center(
              child: Text(
                'Vista previa',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            )));
  }

  Widget textCustom() {
    return Container(
      width: double.infinity,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff2dcc8f))),
              hintText: "Mensaje personalizado"),
        ),
      ),
    );
  }
}

class _ButtonCustom extends StatefulWidget {
  @override
  __ButtonCustomState createState() => __ButtonCustomState();
}

class __ButtonCustomState extends State<_ButtonCustom>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print('add cart');
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xff2dcc8f)),
            child: Center(
              child: Text(
                'Agregar al carrito',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            )));
  }
}
