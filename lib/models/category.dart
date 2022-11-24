import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.color,
  });

  Map<String, dynamic> get updateDto {
    return {
      'id': id,
      'name': name,
      'color': color.value,
    };
  }

  Map<String, dynamic> get createDto {
    return {
      'name': name,
      'color': color.value,
    };
  }

  static Category fromResponse(dynamic c) {
    return Category(
      id: c['_id'],
      name: c['name'],
      color: c['color'] != null ? Color(c['color']) : Colors.lightGreen,
    );
  }

  static Category empty() {
    return Category(
      id: '',
      name: '',
      color: Colors.lightGreen,
    );
  }
}
