// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mayssa_app/shared/constant.dart';

class ControllDirection extends StatelessWidget {
  final String direction;
  VoidCallback onPressed;
  ControllDirection(
      {super.key, required this.direction, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: mainColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SvgPicture.asset(direction),
        ),
      ),
    );
  }
}
