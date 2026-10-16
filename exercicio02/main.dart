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

  String? validarNome(String? valor) {
    final nome = valor?.trim() ?? '';
    if (nome.isEmpty) {
      return 'Informe o nome.';
    }
    if (nome.length < 3) {
      return 'O nome deve ter pelo menos três caracteres.';
    }
    return null;
  }

  void confirmar() {
    final valido = chave.currentState!.validate();
    setState(() {
      mensagem = valido ? 'Olá, ${nomeController.text.trim()}!' : '';
    });
  }

  void limpar() {
    nomeController.clear();
    chave.currentState!.reset();
    setState(() {
      mensagem = '';
    });
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
                validator: validarNome,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: confirmar,
                child: const Text('Confirmar'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: limpar,
                child: const Text('Limpar'),
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
