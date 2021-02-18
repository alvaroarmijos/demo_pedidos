import 'package:flutter/material.dart';

class BtnCustom extends StatelessWidget {
  final String text;
  final Color colorBtn;
  final Color colorText;

  const BtnCustom({Key key, this.text, this.colorBtn, this.colorText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: colorBtn),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Center(
            child: Text(
          text,
          style: TextStyle(color: colorText),
        )),
      ),
    );
  }
}
