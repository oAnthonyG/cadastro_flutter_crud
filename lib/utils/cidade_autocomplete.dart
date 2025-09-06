import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cidade {
  final String nome;
  final String uf;

  Cidade({required this.nome, required this.uf});

  factory Cidade.fromJson(Map<String, dynamic> json) {
    final microrregiao = json['microrregiao'] as Map<String, dynamic>?;
    final mesorregiao = microrregiao?['mesorregiao'] as Map<String, dynamic>?;
    final uf = mesorregiao?['UF'] as Map<String, dynamic>?;

    return Cidade(
      nome: json['nome'] ?? 'Nome desconhecido',
      uf: uf?['sigla'] ?? 'UF',
    );
  }

  @override
  String toString() => '$nome - $uf';
}

Future<List<Cidade>> fetchCidades() async {
  final response = await http.get(
    Uri.parse('https://servicodados.ibge.gov.br/api/v1/localidades/municipios'),
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((json) => Cidade.fromJson(json)).toList();
  } else {
    throw Exception('Erro ao carregar cidades');
  }
}

class CidadeAutocomplete extends StatefulWidget {
  final Function(String cidadeSelecionada) onSaved;
  final String? initialValue;

  const CidadeAutocomplete({
    super.key,
    required this.onSaved,
    this.initialValue,
  });

  @override
  _CidadeAutocompleteState createState() => _CidadeAutocompleteState();
}

class _CidadeAutocompleteState extends State<CidadeAutocomplete> {
  List<Cidade> _cidades = [];
  bool _carregando = true;
  Cidade? _cidadeSelecionada;

  @override
  void initState() {
    super.initState();

    fetchCidades()
        .then((cidades) {
          setState(() {
            _cidades = cidades;
            _carregando = false;
          });
        })
        .catchError((e) {
          setState(() => _carregando = false);
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return CircularProgressIndicator();
    }

    return Autocomplete<Cidade>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Cidade>.empty();
        }

        return _cidades.where(
          (cidade) => cidade.nome.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          ),
        );
      },
      displayStringForOption: (Cidade cidade) => cidade.toString(),
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        if (widget.initialValue != null && controller.text.isEmpty) {
          controller.text = widget.initialValue!;
        }

        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: 'Cidade'),
          validator: (value) {
            final cidadeValida = _cidades.any(
              (cidade) =>
                  cidade.toString().toLowerCase() ==
                  value!.trim().toLowerCase(),
            );

            if (!cidadeValida) return 'Selecione uma cidade válida';
            return null;
          },
          onSaved: (value) => widget.onSaved(value!),
        );
      },
      onSelected: (Cidade selection) {
        _cidadeSelecionada = selection;
      },
    );
  }
}
