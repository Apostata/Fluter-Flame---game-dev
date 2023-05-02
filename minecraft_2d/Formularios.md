# Formulario

Trabalhando com formulários no flutter

## Chave do formulário

É preciso criar uma referencia para acessar os estados do formulários e linka-la com widget de formulário 

```dart
class _ProductManagerEditState extends State<ProductManagerEdit> {
    ...
  final _formKey = GlobalKey<FormState>(); //chave do formulario

  @override
  Widget build(BuildContext context) {
    final id = widget.id;

    return Scaffold(
      ...
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Form(
          key: _formKey, //link entre chave e widget do formulário
          child: ListView(
              ...
          )
        )
      )
  }
...
```

## adicionando controllers aos inputs
para controlar as mudanças em cada input é necessário criar um controller para cada um

```dart
import 'package:flutter/material.dart';

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controlardorNumeroConta =
      TextEditingController();

  FormularioTransferencia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controlardorNumeroConta, //controller
            decoration: const InputDecoration(
              labelText: 'Número da conta',
              hintText: '0000',
            ),
            style: const TextStyle(fontSize: 16.0),
            keyboardType: TextInputType.number,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            debugPrint(_controlardorNumeroConta.text);
            
          },
          child: const Text('Confirmar'),
        )
      ],
    );
  }
}

```