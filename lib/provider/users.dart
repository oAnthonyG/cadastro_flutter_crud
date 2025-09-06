import 'package:cadastro_crud/data/dummy_users.dart';
import 'package:cadastro_crud/models/user.dart';
import 'package:flutter/material.dart';

class UsersProvider with ChangeNotifier {
  final Map<String, User> _items = {...dummyUsers};

  List<User> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  User byIndex(int i) {
    return _items.values.elementAt(i);
  }
}
