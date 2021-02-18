import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/rendering/proxy_box.dart';

class PizzaAnimationProvider with ChangeNotifier {
  final notifierImagePizza = ValueNotifier<PizzaMetada>(null);
  final notifierPizzaBoxAnimation = ValueNotifier(false);

  void startPizzaAnimation() {
    notifierPizzaBoxAnimation.value = true;
    notifyListeners();
  }

  Future<void> transformToImage(RenderRepaintBoundary boundary) async {
    final position = boundary.localToGlobal(Offset.zero);
    final size = boundary.size;

    final image = await boundary.toImage();

    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);

    notifierImagePizza.value =
        PizzaMetada(byteData.buffer.asUint8List(), position, size);
  }
}

class PizzaMetada {
  final Uint8List imageBytes;
  final Offset position;
  final Size size;

  PizzaMetada(this.imageBytes, this.position, this.size);
}
