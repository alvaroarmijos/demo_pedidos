import 'package:demo_pedidos/modules/provider/pizza_animation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const _pizzaCartSize = 48.0;

class PizzaOrderDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pizza',
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
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _PizzaDetails(),
                    ),
                    Container(height: 200, child: _PizzaIngredients()),
                    SizedBox(
                      height: 20,
                    )
                  ],
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

class _PizzaDetails extends StatefulWidget {
  @override
  __PizzaDetailsState createState() => __PizzaDetailsState();
}

class __PizzaDetailsState extends State<_PizzaDetails>
    with SingleTickerProviderStateMixin {
  final _keyPizza = GlobalKey();
  final _listingredients = <String>[];
  final _listingredientsUnit = <String>[];

  AnimationController animationController;

  final _notifierFocused = ValueNotifier(false);

  int totalUnitario = 15;
  int total = 15;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<PizzaAnimationProvider>(context, listen: false);
      provider.notifierPizzaBoxAnimation.addListener(() {
        _addPizzaToCart();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pizzaProvider = Provider.of<PizzaAnimationProvider>(context);
    int subtotal;
    return Column(
      children: [
        Expanded(
          child: DragTarget<String>(
            onAccept: (ingredient) {
              print('accept');

              _notifierFocused.value = false;

              setState(() {
                _listingredients.add(ingredient);

                if (count > 1) {
                  count = 1;
                }

                totalUnitario++;
                total = totalUnitario;
              });
              _buildIngredientsAnimation();
              animationController.forward(from: 0.0);
            },
            onWillAccept: (ingredient) {
              print('WillAccept');

              _notifierFocused.value = true;

              //se compara si el ingrediente ya esta en la pizza
              for (String i in _listingredients) {
                if (i == ingredient) {
                  return false;
                }
              }

              return true;
            },
            onLeave: (ingredient) {
              print('leave');

              _notifierFocused.value = false;
            },
            builder: (context, list, rejects) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  _pizzaConstraints = constraints;
                  return ValueListenableBuilder<PizzaMetada>(
                      valueListenable: pizzaProvider.notifierImagePizza,
                      builder: (context, data, child) {
                        if (data != null) {
                          //Future.microtask(() => _startPizzaBoxAnimation(data));
                        }

                        return RepaintBoundary(
                          key: _keyPizza,
                          child: Stack(
                            children: [
                              Center(
                                  child: ValueListenableBuilder<bool>(
                                valueListenable: _notifierFocused,
                                builder: (context, value, child) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    height: value
                                        ? constraints.maxHeight
                                        : constraints.maxHeight - 50,
                                    child: Stack(
                                      children: [
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 15.0,
                                                    color: Colors.black12,
                                                    offset: Offset(0.0, 5.0),
                                                    spreadRadius: 5.0),
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child:
                                                Image.asset('assets/dish.png'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child:
                                              Image.asset('assets/pizza-1.png'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )),
                              AnimatedBuilder(
                                animation: animationController,
                                builder: (BuildContext context, Widget child) {
                                  return _buildIngredientsWidget();
                                },
                              )
                            ],
                          ),
                        );
                      });
                },
              );
            },
          ),
        ),
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
              )
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
      ],
    );
  }

  void _addPizzaToCart() {
    final pizzaProvider =
        Provider.of<PizzaAnimationProvider>(context, listen: false);

    RenderRepaintBoundary boundary =
        _keyPizza.currentContext.findRenderObject();

    pizzaProvider.transformToImage(boundary);
  }

  OverlayEntry _overlayEntry;

  void _startPizzaBoxAnimation(PizzaMetada metadata) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (context) {
        return PizzaOrderAnimation(
          metada: metadata,
          onComplete: () {
            _overlayEntry.remove();
            _overlayEntry = null;
          },
        );
      });

      Overlay.of(context).insert(_overlayEntry);
    }
  }
}

class PizzaOrderAnimation extends StatefulWidget {
  final PizzaMetada metada;
  final VoidCallback onComplete;

  const PizzaOrderAnimation({Key key, this.metada, this.onComplete})
      : super(key: key);

  @override
  _PizzaOrderAnimationState createState() => _PizzaOrderAnimationState();
}

class _PizzaOrderAnimationState extends State<PizzaOrderAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onComplete();
      },
      child: Center(child: Image.memory(widget.metada.imageBytes)),
    );
  }
}

class _ButtonCustom extends StatefulWidget {
  @override
  __ButtonCustomState createState() => __ButtonCustomState();
}

class __ButtonCustomState extends State<_ButtonCustom>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print('add cart');
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

          // Provider.of<PizzaAnimationProvider>(context, listen: false)
          //     .startPizzaAnimation();
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

class _PizzaIngredients extends StatelessWidget {
  List<String> ingredients = [
    'chili',
    'mushroom',
    'olive',
    'onion',
    'pea',
    'pickle',
    'potato',
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: ingredients.length,
      itemBuilder: (BuildContext context, int index) {
        final ingredient = ingredients[index];
        return _PizzaIngredientItems(
          ingredient: ingredient,
        );
      },
    );
  }
}

class _PizzaIngredientItems extends StatelessWidget {
  final String ingredient;

  const _PizzaIngredientItems({this.ingredient});
  @override
  Widget build(BuildContext context) {
    final child = Container(
      height: 45,
      width: 45,
      decoration:
          BoxDecoration(color: Color(0xFFF5EED3), shape: BoxShape.circle),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset('assets/$ingredient.png', fit: BoxFit.contain),
      ),
    );
    return Center(
      child: Draggable(
        feedback: DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(
                blurRadius: 10.0,
                color: Colors.black26,
                offset: Offset(0.0, 5.0),
                spreadRadius: 5.0)
          ]),
          child: child,
        ),
        data: ingredient,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10), child: child),
      ),
    );
  }
}
