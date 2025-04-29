import 'package:flutter/material.dart';

class NotionItem {
  final String id;
  final String title;
  final String description;
  late bool isChecked;
  NotionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isChecked,
  });
}

class Home extends ChangeNotifier {
  List<NotionItem> _notionItem = [];
  // Create Read Update Delete
  List<NotionItem> get notionItem => _notionItem;

  void addItem(String title, String desc, bool isChecked) {
    final newItem = NotionItem(
      id: DateTime.now().toString(),
      title: title,
      description: desc,
      isChecked: isChecked,
    );
    _notionItem.add(newItem);
    notifyListeners();
  }

  void updateItem(
    String id,
    String newTitle,
    String newDesc,
    bool newIsChecked,
  ) {
    final idx = _notionItem.indexWhere((item) => item.id == id);
    if (idx != -1) {
      _notionItem[idx] = NotionItem(
        id: id,
        title: newTitle,
        description: newDesc,
        isChecked: newIsChecked,
      );
      notifyListeners();
    }
  }

  void deleteItem(String id) {
    _notionItem.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
