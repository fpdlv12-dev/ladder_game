import 'package:flutter/material.dart';

/// 참가자별 경로 색 (최대 10명). 서로 구분이 잘 되는 순서로.
const kPlayerColors = <Color>[
  Color(0xFFE53935),
  Color(0xFF1E88E5),
  Color(0xFF43A047),
  Color(0xFFFB8C00),
  Color(0xFF8E24AA),
  Color(0xFF00ACC1),
  Color(0xFFF4511E),
  Color(0xFF3949AB),
  Color(0xFF7CB342),
  Color(0xFFD81B60),
];

Color playerColor(int index) => kPlayerColors[index % kPlayerColors.length];
