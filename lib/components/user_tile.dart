import 'package:cadastro_crud/models/user.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final User user;
  const UserTile(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.edit), color: Colors.orange, onPressed: () {}),
            IconButton(icon: Icon(Icons.delete), color: Colors.red, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
