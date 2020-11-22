import 'package:flutter/material.dart';

kBoxDecorationStyle() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 0.5,
        blurRadius: 12,
      ),
    ],
  );
}
