import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class City {
  final String nome;
  final String uf;

  City({required this.nome, required this.uf});

  factory City.fromJson(Map<String, dynamic> json) {
    final microrregiao = json['microrregiao'] as Map<String, dynamic>?;
    final mesorregiao = microrregiao?['mesorregiao'] as Map<String, dynamic>?;
    final uf = mesorregiao?['UF'] as Map<String, dynamic>?;

    return City(
      nome: json['nome'] ?? 'Nome desconhecido',
      uf: uf?['sigla'] ?? 'UF',
    );
  }

  @override
  String toString() => '$nome - $uf';
}

Future<List<City>> fetchCities() async {
  final response = await http.get(
    Uri.parse('https://servicodados.ibge.gov.br/api/v1/localidades/municipios'),
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((json) => City.fromJson(json)).toList();
  } else {
    throw Exception('Erro ao carregar cities');
  }
}

class AutocompleteCities extends StatefulWidget {
  final Function(String selectedCities) onSaved;
  final String? initialValue;

  const AutocompleteCities({
    super.key,
    required this.onSaved,
    this.initialValue,
  });

  @override
  AutocompleteCitiesState createState() => AutocompleteCitiesState();
}

class AutocompleteCitiesState extends State<AutocompleteCities> {
  List<City> _cities = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    fetchCities()
        .then((cities) {
          setState(() {
            _cities = cities;
            _loading = false;
          });
        })
        .catchError((e) {
          setState(() => _loading = false);
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator();
    }

    return Autocomplete<City>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<City>.empty();
        }

        return _cities.where(
          (cities) => cities.nome.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          ),
        );
      },
      displayStringForOption: (City cities) => cities.toString(),
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        if (widget.initialValue != null && controller.text.isEmpty) {
          controller.text = widget.initialValue!;
        }

        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: 'Cidade'),
          validator: (value) {
            final validCity = _cities.any(
              (cities) =>
                  cities.toString().toLowerCase() ==
                  value!.trim().toLowerCase(),
            );

            if (!validCity) return 'Selecione uma cidade válida';
            return null;
          },
          onSaved: (value) => widget.onSaved(value!),
        );
      },
      onSelected: (City selection) {
      },
    );
  }
}
