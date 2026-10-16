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
  final int quantidade;

  const Produto({
    required this.nome,
    required this.preco,
    required this.descricao,
    required this.quantidade,
  });

  double get valorEmEstoque => preco * quantidade;
}

class TelaProdutos extends StatefulWidget {
  const TelaProdutos({super.key});

  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  final List<Produto> produtos = [];
  final buscaController = TextEditingController();
  String busca = '';

  List<Produto> get produtosVisiveis {
    final termo = busca.trim().toLowerCase();
    if (termo.isEmpty) return produtos;
    return produtos
        .where((produto) => produto.nome.toLowerCase().contains(termo))
        .toList();
  }

  List<String> nomesExceto(Produto? ignorado) {
    return [
      for (final produto in produtos)
        if (!identical(produto, ignorado)) produto.nome,
    ];
  }

  double calcularTotalEstoque() {
    double total = 0;
    for (final produto in produtos) {
      total += produto.valorEmEstoque;
    }
    return total;
  }

  void avisar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> cadastrar() async {
    final novo = await Navigator.push<Produto>(
      context,
      MaterialPageRoute<Produto>(
        builder: (_) => TelaFormulario(nomesExistentes: nomesExceto(null)),
      ),
    );
    if (!mounted || novo == null) return;
    setState(() {
      produtos.add(novo);
    });
    avisar('Produto cadastrado com sucesso.');
  }

  Future<void> abrirDetalhes(Produto produto) async {
    final atualizado = await Navigator.push<Produto>(
      context,
      MaterialPageRoute<Produto>(
        builder: (_) => TelaDetalhes(
          produto: produto,
          nomesExistentes: nomesExceto(produto),
        ),
      ),
    );
    if (!mounted || atualizado == null) return;
    final indice = produtos.indexOf(produto);
    if (indice == -1) {
      avisar('Produto não encontrado. Nada foi alterado.');
      return;
    }
    setState(() {
      produtos[indice] = atualizado;
    });
    avisar('Produto atualizado.');
  }

  Future<void> excluir(Produto produto) async {
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
    final indice = produtos.indexOf(produto);
    if (indice == -1) {
      avisar('Produto não encontrado. Nada foi excluído.');
      return;
    }
    setState(() {
      produtos.removeAt(indice);
    });
    avisar('Produto excluído.');
  }

  @override
  void dispose() {
    buscaController.dispose();
    super.dispose();
  }

  Widget construirLista(List<Produto> visiveis) {
    if (produtos.isEmpty) {
      return const Center(child: Text('Nenhum produto cadastrado.'));
    }
    if (visiveis.isEmpty) {
      return const Center(child: Text('Nenhum produto encontrado.'));
    }
    return ListView.builder(
      itemCount: visiveis.length,
      itemBuilder: (context, indice) {
        final produto = visiveis[indice];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text(produto.nome),
            subtitle: Text(
              'R\$ ${produto.preco.toStringAsFixed(2)}'
              ' • Estoque: ${produto.quantidade}'
              ' • Valor: R\$ '
              '${produto.valorEmEstoque.toStringAsFixed(2)}',
            ),
            onTap: () => abrirDetalhes(produto),
            trailing: IconButton(
              tooltip: 'Excluir produto',
              icon: const Icon(Icons.delete),
              onPressed: () => excluir(produto),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visiveis = produtosVisiveis;
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos em memória')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              controller: buscaController,
              decoration: InputDecoration(
                labelText: 'Buscar pelo nome',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: busca.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpar busca',
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          buscaController.clear();
                          setState(() {
                            busca = '';
                          });
                        },
                      ),
              ),
              onChanged: (valor) {
                setState(() {
                  busca = valor;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Produtos cadastrados: ${produtos.length}'),
                Text('Produtos encontrados: ${visiveis.length}'),
                const SizedBox(height: 4),
                Text(
                  'Valor total do estoque: '
                  'R\$ ${calcularTotalEstoque().toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(child: construirLista(visiveis)),
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
  final List<String> nomesExistentes;

  const TelaDetalhes({
    super.key,
    required this.produto,
    required this.nomesExistentes,
  });

  Future<void> editar(BuildContext context) async {
    final atualizado = await Navigator.push<Produto>(
      context,
      MaterialPageRoute<Produto>(
        builder: (_) => TelaFormulario(
          produto: produto,
          nomesExistentes: nomesExistentes,
        ),
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
            Text('Quantidade em estoque: ${produto.quantidade}'),
            const SizedBox(height: 12),
            Text(
              'Valor em estoque: '
              'R\$ ${produto.valorEmEstoque.toStringAsFixed(2)}',
            ),
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
  final List<String> nomesExistentes;

  const TelaFormulario({
    super.key,
    this.produto,
    this.nomesExistentes = const [],
  });

  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final chave = GlobalKey<FormState>();
  late final TextEditingController nomeController;
  late final TextEditingController precoController;
  late final TextEditingController descricaoController;
  late final TextEditingController quantidadeController;

  @override
  void initState() {
    super.initState();
    final produto = widget.produto;
    nomeController = TextEditingController(text: produto?.nome ?? '');
    precoController = TextEditingController(
      text: produto?.preco.toString() ?? '',
    );
    quantidadeController = TextEditingController(
      text: produto?.quantidade.toString() ?? '',
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
    final normalizado = normalizarNome(nome);
    final repetido = widget.nomesExistentes.any(
      (existente) => normalizarNome(existente) == normalizado,
    );
    if (repetido) return 'Já existe um produto com esse nome.';
    return null;
  }

  String normalizarNome(String nome) => nome.trim().toLowerCase();

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

  int? converterQuantidade(String texto) {
    return int.tryParse(texto.trim());
  }

  String? validarQuantidade(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe a quantidade.';
    }
    final quantidade = converterQuantidade(valor);
    if (quantidade == null) {
      return 'Digite um número inteiro.';
    }
    if (quantidade < 0) return 'A quantidade não pode ser negativa.';
    return null;
  }

  void salvar() {
    if (!chave.currentState!.validate()) return;
    final produto = Produto(
      nome: nomeController.text.trim(),
      preco: converterPreco(precoController.text)!,
      descricao: descricaoController.text.trim(),
      quantidade: converterQuantidade(quantidadeController.text)!,
    );
    Navigator.pop(context, produto);
  }

  @override
  void dispose() {
    nomeController.dispose();
    precoController.dispose();
    descricaoController.dispose();
    quantidadeController.dispose();
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
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantidade em estoque',
                ),
                validator: validarQuantidade,
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
