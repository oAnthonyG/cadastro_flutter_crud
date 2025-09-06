import 'package:cadastro_crud/provider/users.dart';
import 'package:cadastro_crud/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:cadastro_crud/components/user_tile.dart';
import 'package:provider/provider.dart';

class UserList extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final UsersProvider users = Provider.of(context);
    final userList = users.all;
  
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Usuários',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.USER_FORM);
            },
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: users.count,
        itemBuilder: (ctx, i) {
          final user = userList[i];
          return UserTile(user, key: ValueKey(user.id));
        },
      ),
    );
  }
}
