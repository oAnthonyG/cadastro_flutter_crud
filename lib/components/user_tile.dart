import 'package:cadastro_crud/models/user.dart';
import 'package:cadastro_crud/provider/users.dart';
import 'package:cadastro_crud/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {
  final User user;
  const UserTile(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
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
                ).pushNamed(AppRoutes.USER_FORM, arguments: user);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                final usersProvider = Provider.of<UsersProvider>(context, listen: false);

                showDialog(context: context, builder: (ctx) => AlertDialog(
                  title: Text('Excluir Usuário'),
                  content: Text('Tem certeza?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Não'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: Text('Sim'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                )).then((confirmed) {
                  if (confirmed != null && confirmed) {
                    usersProvider.remove(user);
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
