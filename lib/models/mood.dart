import 'package:flutter/material.dart';

class Mood {
  final String id;
  final String title;
  final Color color;

  const Mood({
    required this.id,
    required this.title,
    required this.color,
  });
}