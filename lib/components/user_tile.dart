import 'package:cadastro_crud/models/user.dart';
import 'package:cadastro_crud/provider/users.dart';
import 'package:cadastro_crud/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTile extends StatefulWidget {
  final User user;
  const UserTile(this.user, {super.key});

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.user.name),
      subtitle: Text(widget.user.email),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.orange,
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutes.USER_FORM, arguments: widget.user);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                final usersProvider = Provider.of<UsersProvider>(
                  context,
                  listen: false,
                );

                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Excluir Usuário'),
                    content: Text('Tem certeza?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Não'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: Text('Sim'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                ).then((confirmed) {
                  if (confirmed) {
                    usersProvider.remove(widget.user);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
