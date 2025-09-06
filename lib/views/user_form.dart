import 'package:cadastro_crud/models/user.dart';
import 'package:cadastro_crud/provider/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UseForm extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Usuário'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: () {
              final isValid = _form.currentState?.validate();

              if (isValid != null && isValid) {
                _form.currentState?.save();

                
                Provider.of<UsersProvider>(context, listen: false).put(
                  User(
                    id: _formData['id'] ?? '',
                    name: _formData['name']!,
                    email: _formData['email']!,
                    telefone: _formData['telefone']!,
                    cidade: _formData['cidade']!,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome inválido';
                  }
                  if (value.trim().length < 3) {
                    return 'Nome muito curto. Mínimo 3 letras';
                  }
                  return null;
                },
                onSaved: (value) => _formData['name'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome inválido';
                  }
                  if (value.trim().length < 3) {
                    return 'Nome muito curto. Mínimo 3 letras';
                  }
                  return null;
                },
                onSaved: (value) => _formData['email'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Telefone inválido';
                  }
                  if (value.trim().length < 3) {
                    return 'Telefone muito curto. Mínimo 3 letras';
                  }
                  return null;
                },
                onSaved: (value) => _formData['telefone'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cidade'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'cidade inválido';
                  }
                  if (value.trim().length < 3) {
                    return 'Cidade muito curto. Mínimo 3 letras';
                  }
                  return null;
                },
                onSaved: (value) => _formData['cidade'] = value!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
