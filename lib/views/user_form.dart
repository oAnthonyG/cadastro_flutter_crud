import 'package:cadastro_crud/models/user.dart';
import 'package:cadastro_crud/provider/users.dart';
import 'package:cadastro_crud/utils/city_validate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UseForm extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  void _loadFormData(User user) {
    _formData['id'] = user.id;
    _formData['name'] = user.name;
    _formData['email'] = user.email;
    _formData['telefone'] = user.telefone;
    _formData['cidade'] = user.cidade;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = ModalRoute.of(context)?.settings.arguments as User?;
    if (user != null) {
      _loadFormData(user);
    }

    bool isValidPhoneNumber(String phone) {
      final RegExp phoneExp = RegExp(r'^\(?\d{2}\)?[\s-]?\d{4,5}-?\d{4}$');
      return phoneExp.hasMatch(phone);
    }

    bool isValidEmail(String email) {
      final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return regex.hasMatch(email);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Formulário de Usuário',
          style: TextStyle(color: Colors.white),
        ),
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
                initialValue: _formData['name'],
                keyboardType: TextInputType.name,
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
                initialValue: _formData['email'],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite um email válido';
                  }
                  if (!isValidEmail(value)) {
                    return 'Email inválido';
                  }
                  return null;
                },
                onSaved: (value) => _formData['email'] = value!,
              ),
              TextFormField(
                initialValue: _formData['telefone'],

                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Telefone inválido';
                  }
                  if (!isValidPhoneNumber(value)) {
                    return 'Número de telefone inválido';
                  }
                  return null;
                },
                onSaved: (value) => _formData['telefone'] = value!,
              ),
              AutocompleteCities(
                initialValue: _formData['cidade'],
                onSaved: (cidade) => _formData['cidade'] = cidade,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
