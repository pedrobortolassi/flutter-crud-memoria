import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaNome(),
    );
  }
}

class TelaNome extends StatefulWidget {
  const TelaNome({super.key});

  @override
  State<TelaNome> createState() => _TelaNomeState();
}

class _TelaNomeState extends State<TelaNome> {
  final chave = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  String mensagem = '';

  void confirmar() {
    if (chave.currentState!.validate()) {
      setState(() {
        mensagem = 'Olá, ${nomeController.text.trim()}!';
      });
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nome validado')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: chave,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: confirmar,
                child: const Text('Confirmar'),
              ),
              const SizedBox(height: 20),
              Text(mensagem),
            ],
          ),
        ),
      ),
    );
  }
}
