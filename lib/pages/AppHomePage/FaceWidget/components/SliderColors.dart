import 'package:flutter/material.dart';

Animatable<Color> backgroundTween = TweenSequence<Color>([
  TweenSequenceItem(
    tween: ColorTween(
      begin: Color(0xFFFF0000),
      end: Color(0xFF70C100),
    ),
    weight: 1.0,
  ),
  TweenSequenceItem(
    tween: ColorTween(
      begin: Color(0xFF70C100),
      end: Color(0xFFFFFFFF),
    ),
    weight: 1.0,
  ),
  TweenSequenceItem(
    tween: ColorTween(
      begin: Color(0xFFFFFFFF),
      end: Color(0xFFFFFFFF),
    ),
    weight: 1.0,
  ),
  TweenSequenceItem(
    tween: ColorTween(
      begin: Color(0xFFFFFFFF),
      end: Color(0xFFF8ECBD),
    ),
    weight: 1.0,
  ),
  TweenSequenceItem(
    tween: ColorTween(
      begin: Color(0xFFF8ECBD),
      end: Color(0xFF20BEFD),
    ),
    weight: 1.0,
  ),
]);
