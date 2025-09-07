import 'dart:math';

import 'package:cadastro_crud/models/user.dart';
import 'package:flutter/material.dart';

class UsersProvider with ChangeNotifier {
  final Map<String, User> _items = {};

  List<User> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  User byIndex(int i) {
    return _items.values.elementAt(i);
  }

  void put(User user) {

    if (user.id.trim().isNotEmpty &&
        _items.containsKey(user.id)) {
      _items.update(
        user.id,
        (_) => User(
          id: user.id,
          name: user.name,
          email: user.email,
          telefone: user.telefone,
          cidade: user.cidade,
        ),
      );
    } else {
      final id = Random().nextDouble().toString();
      _items.putIfAbsent(
        id,
        () => User(
          id: id,
          name: user.name,
          email: user.email,
          telefone: user.telefone,
          cidade: user.cidade,
        ),
      );
    }

    notifyListeners();
  }

  void remove(User user) {
    if (user.id.trim().isNotEmpty) {
      _items.remove(user.id);
      notifyListeners();
    }
  }

}
