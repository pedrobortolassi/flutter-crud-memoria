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
      home: TelaProdutos(),
    );
  }
}

class Produto {
  final String nome;
  final double preco;
  final String descricao;

  const Produto({
    required this.nome,
    required this.preco,
    required this.descricao,
  });
}

class TelaProdutos extends StatefulWidget {
  const TelaProdutos({super.key});

  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  final List<Produto> produtos = [];

  void avisar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> cadastrar() async {
    final novo = await Navigator.push<Produto>(
      context,
      MaterialPageRoute<Produto>(
        builder: (_) => const TelaFormulario(),
      ),
    );
    if (!mounted || novo == null) return;
    setState(() {
      produtos.add(novo);
    });
    avisar('Produto cadastrado com sucesso.');
  }

  Future<void> abrirDetalhes(int indice) async {
    final atualizado = await Navigator.push<Produto>(
      context,
      MaterialPageRoute<Produto>(
        builder: (_) => TelaDetalhes(produto: produtos[indice]),
      ),
    );
    if (!mounted || atualizado == null) return;
    setState(() {
      produtos[indice] = atualizado;
    });
    avisar('Produto atualizado.');
  }

  Future<void> excluir(int indice) async {
    final produto = produtos[indice];
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) => AlertDialog(
        title: const Text('Excluir produto'),
        content: Text('Deseja excluir ${produto.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, false),
            child: const Text('Manter produto'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (!mounted || confirmou != true) return;
    setState(() {
      produtos.removeAt(indice);
    });
    avisar('Produto excluído.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos em memória')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Produtos cadastrados: ${produtos.length}'),
          ),
          Expanded(
            child: produtos.isEmpty
                ? const Center(child: Text('Nenhum produto cadastrado.'))
                : ListView.builder(
                    itemCount: produtos.length,
                    itemBuilder: (context, indice) {
                      final produto = produtos[indice];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(produto.nome),
                          subtitle: Text(
                            'R\$ ${produto.preco.toStringAsFixed(2)}',
                          ),
                          onTap: () => abrirDetalhes(indice),
                          trailing: IconButton(
                            tooltip: 'Excluir produto',
                            icon: const Icon(Icons.delete),
                            onPressed: () => excluir(indice),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: cadastrar,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TelaDetalhes extends StatelessWidget {
  final Produto produto;

  const TelaDetalhes({super.key, required this.produto});

  Future<void> editar(BuildContext context) async {
    final atualizado = await Navigator.push<Produto>(
      context,
      MaterialPageRoute<Produto>(
        builder: (_) => TelaFormulario(produto: produto),
      ),
    );
    if (!context.mounted || atualizado == null) return;
    Navigator.pop(context, atualizado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do produto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(produto.nome, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 12),
            Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            Text(produto.descricao.isEmpty
                ? 'Sem descrição.'
                : produto.descricao),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => editar(context),
              child: const Text('Editar'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaFormulario extends StatefulWidget {
  final Produto? produto;

  const TelaFormulario({super.key, this.produto});

  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final chave = GlobalKey<FormState>();
  late final TextEditingController nomeController;
  late final TextEditingController precoController;
  late final TextEditingController descricaoController;

  @override
  void initState() {
    super.initState();
    final produto = widget.produto;
    nomeController = TextEditingController(text: produto?.nome ?? '');
    precoController = TextEditingController(
      text: produto?.preco.toString() ?? '',
    );
    descricaoController = TextEditingController(
      text: produto?.descricao ?? '',
    );
  }

  static const limiteDescricao = 120;

  String? validarNome(String? valor) {
    final nome = valor?.trim() ?? '';
    if (nome.isEmpty) return 'Informe o nome.';
    if (nome.length < 3) {
      return 'O nome deve ter pelo menos três caracteres.';
    }
    return null;
  }

  String? validarDescricao(String? valor) {
    final descricao = valor?.trim() ?? '';
    if (descricao.length > limiteDescricao) {
      return 'A descrição deve ter no máximo $limiteDescricao caracteres '
          '(atual: ${descricao.length}).';
    }
    return null;
  }

  double? converterPreco(String texto) {
    return double.tryParse(texto.trim().replaceAll(',', '.'));
  }

  String? validarPreco(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o preço.';
    }
    final preco = converterPreco(valor);
    if (preco == null || !preco.isFinite) {
      return 'Digite um número válido.';
    }
    if (preco <= 0) return 'O preço deve ser maior que zero.';
    return null;
  }

  void salvar() {
    if (!chave.currentState!.validate()) return;
    final produto = Produto(
      nome: nomeController.text.trim(),
      preco: converterPreco(precoController.text)!,
      descricao: descricaoController.text.trim(),
    );
    Navigator.pop(context, produto);
  }

  @override
  void dispose() {
    nomeController.dispose();
    precoController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.produto != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar produto' : 'Cadastrar produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: chave,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: validarNome,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: precoController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Preço'),
                validator: validarPreco,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição opcional',
                  helperText: 'Máximo de $limiteDescricao caracteres.',
                ),
                maxLines: 3,
                validator: validarDescricao,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: salvar,
                child: const Text('Salvar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  editando ? 'Descartar alterações' : 'Cancelar cadastro',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
