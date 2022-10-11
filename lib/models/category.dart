class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  Map<String, String> get updateDto {
    return {
      'id': id,
      'name': name
    };
  }

  Map<String, String> get createDto {
    return {
      'name': name
    };
  }

  static Category fromResponse(dynamic c) {
    return Category(
      id: c['_id'],
      name: c['name'],
    );
  }

  static Category empty() {
    return Category(
        id: '',
        name: '',
    );
  }
}
